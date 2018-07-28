//
//  ViewController.swift
//  RACameraHelper
//
//  Created by Bobby on 06/13/2018.
//  Copyright (c) 2018 Bobby. All rights reserved.
//

import UIKit
import RACameraHelper

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var button: UIButton!
    let cameraHelper = CameraHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraHelper.delegate = self
        button.setTitle("Add Photo", for: .normal)
    }

    @IBAction func didClickButton(_ sender: Any?) {
        cameraHelper.takeOrSelectPhoto(from: self, fromView: button)
    }
}

extension ViewController: CameraHelperDelegate {
    func didCancelSelection() {
        print("Did not edit image")
    }
    
    func didCancelPicker() {
        print("Did not select image")
        dismiss(animated: true, completion: nil)
    }
    
    func didSelectPhoto(selected: UIImage?) {
        let frameworkBundle = Bundle(for: PhotoCropViewController.self)
        let bundleURL = frameworkBundle.path(forResource: "RACameraHelper", ofType: "bundle")
        let resourceBundle = Bundle(url: URL(fileURLWithPath: bundleURL!))
        guard let nav = UIStoryboard(name: "RACameraHelper", bundle: resourceBundle).instantiateInitialViewController() as? UINavigationController, let controller = nav.viewControllers[0] as? PhotoCropViewController else { return }
        controller.image = selected
        controller.delegate = self
        dismiss(animated: true) {
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension ViewController: PhotoCropDelegate {
    func didFinishEditing(photo: UIImage?) {
        photoView.image = photo
        button.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    
}

