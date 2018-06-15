//
//  CameraHelper.swift
//  RACameraHelper
//
//  Created by Bobby Ren on 6/13/18.
//  Copyright © 2018 RenderApps. All rights reserved.
//

import UIKit
import Photos

public protocol CameraHelperDelegate: class {
    func didCancelSelection() // album or camera
    func didCancelPicker() // cancel from picker
    func didSelectPhoto(selected: UIImage?)
}

public class CameraHelper: NSObject {
    weak var rootViewController: UIViewController?
    weak var delegate: CameraHelperDelegate?
    fileprivate var sourceIsCamera: Bool = false
    
    func takeOrSelectPhoto(from root: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take a New Photo", style: .default, handler: { (action) in
                self.selectPhotoSource(camera: true)
            }))
        }
        alert.addAction(UIAlertAction(title: "Choose an Existing Photo", style: .default, handler: { (action) in
            self.selectPhotoSource(camera: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.delegate?.didCancelSelection()
        })
        rootViewController = root
        root.present(alert, animated: true, completion: nil)
    }
}

// MARK: Camera
extension CameraHelper {
    fileprivate func selectPhotoSource(camera: Bool) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        sourceIsCamera = camera
        
        picker.view.backgroundColor = .blue
        UIApplication.shared.isStatusBarHidden = false
        
        if camera, UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.showsCameraControls = true
            picker.cameraDevice = .front
            
            rootViewController?.present(picker, animated: true)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker.sourceType = .photoLibrary
            }
            else {
                picker.sourceType = .savedPhotosAlbum
            }
            picker.navigationBar.isTranslucent = false
            
            PHPhotoLibrary.requestAuthorization { (status) in
                self.rootViewController?.present(picker, animated: true)
            }
        }
    }
}


// MARK: Photo selection
extension CameraHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let original = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        delegate?.didSelectPhoto(selected: original)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.didCancelPicker()
    }
}
