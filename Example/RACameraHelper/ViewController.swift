//
//  ViewController.swift
//  RACameraHelper
//
//  Created by Bobby on 06/13/2018.
//  Copyright (c) 2018 Bobby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    let cameraHelper = CameraHelper()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraHelper.delegate = self
    }

    @IBAction func didClickButton(_ sender: Any?) {
        cameraHelper.takeOrSelectPhoto(from: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? PhotoCropViewController else { return }
        controller.image = selectedImage
        controller.delegate = self
        dismiss(animated: true) {
            self.present(controller, animated: true)
        }
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
        selectedImage = selected
        performSegue(withIdentifier: "toEditPhoto", sender: nil)
    }
}

extension ViewController: PhotoCropDelegate {
    func didFinishEditing(photo: UIImage?) {
        photoView.image = photo
        dismiss(animated: true, completion: nil)
    }
    
    
}

