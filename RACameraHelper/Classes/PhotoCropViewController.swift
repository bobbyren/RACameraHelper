//
//  PhotoCropViewController.swift
//  RACameraHelper
//
//  Created by Bobby Ren on 6/13/18.
//  Copyright © 2018 RenderApps. All rights reserved.
//

import UIKit

protocol PhotoCropDelegate: class {
    func didFinishEditing(photo: UIImage?)
}

class PhotoCropViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var buttonSelect: UIButton!
    
    weak var delegate: PhotoCropDelegate?
    private lazy var __once: () = {
        // sets up scrollview only once
        setupScrollView()
    }()
    
    var image: UIImage? {
        didSet {
            if let photoView = photoView {
                photoView.image = image
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        // Do any additional setup after loading the view.
        cropView.layer.borderWidth = 2
        cropView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let _ = __once
    }
    
    fileprivate func setupNavBar() {
        // note: the calculations for photoView and scrollView depend on the nav bar. it is off by 44 pixels without.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .black
    }
    
    @IBAction func didClickSelect(_ sender: Any) {
        let cropped = createSnapshot(in: cropView.frame)
        delegate?.didFinishEditing(photo: cropped)
    }
    
    @IBAction func close() {
        delegate?.didFinishEditing(photo: nil)
    }
    
    fileprivate func setupScrollView() {
        guard let image = image else { return }
        photoView.image = image
        
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        
        // amount of space between scrollView's content origin and photo's top when it is in crop frame
        let cropFrameOffset = (height - cropView.frame.size.height) / 2
        
        // if photo matches bottom of cropFrame but is smaller, a larger offset is needed at the top and bottom of the photo
        let photoHeight = width / image.size.width * image.size.height
        let photoOffset = max(cropFrameOffset, height - cropFrameOffset - photoHeight)
        
        photoView.frame = CGRect(x: 0, y: photoOffset, width: width, height: photoHeight)
        
        scrollView.delegate = self
        let contentHeight = 2 * photoOffset + photoHeight
        scrollView.contentSize = CGSize(width: width, height: contentHeight)
        let contentOffsetY = (contentHeight - height) / 2
        scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY)
    }
    
    fileprivate func updateContentSize() {
        let height = scrollView.frame.size.height
        
        // amount of space between scrollView's content origin and photo's top when it is in crop frame
        let cropFrameOffset = (height - cropView.frame.size.height) / 2
        
        // if photo matches bottom of cropFrame but is smaller, a larger offset is needed at the top and bottom of the photo
        let photoHeight = photoView.frame.size.height
        let photoWidth = photoView.frame.size.width
        let photoOffset = max(cropFrameOffset, height - cropFrameOffset - photoHeight)
        photoView.frame = CGRect(x: 0, y: photoOffset, width: photoWidth, height: photoHeight)
        
        let contentHeight = 2 * photoOffset + photoHeight
        scrollView.contentSize = CGSize(width: photoWidth, height: contentHeight)
    }
    
    // MARK: - custom cropping
    // https://stackoverflow.com/questions/48785503/uiimagepickercontroller-cropping-image-rect-is-not-correct
    fileprivate func snapshotImageFor(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    fileprivate func createSnapshot(in rect: CGRect) -> UIImage? {
        let temporaryView = UIView(frame: rect) // This is a view from which the snapshot will occure
        temporaryView.clipsToBounds = true
        view.addSubview(temporaryView) // We want to put it into hierarchy
        
        guard let viewToSnap = photoView else { return nil } // We want to use the superview of the scrollview because using scroll view directly may have some issues.
        
        let originalImageViewFrame = viewToSnap.frame // Preserve previous frame
        guard let originalImageViewSuperview = viewToSnap.superview else { return nil } // Preserve previous superview
        guard let index = originalImageViewSuperview.subviews.index(of: viewToSnap) else { return nil } // Preserve view hierarchy index
        
        // Now change the frame and put it on the new view
        viewToSnap.frame = originalImageViewSuperview.convert(originalImageViewFrame, to: temporaryView)
        temporaryView.addSubview(viewToSnap)
        
        // Create snapshot
        let croppedImage = snapshotImageFor(view: temporaryView)
        
        // Put everything back the way it was
        viewToSnap.frame = originalImageViewFrame // Reset frame
        originalImageViewSuperview.insertSubview(viewToSnap, at: index) // Reset superview
        temporaryView.removeFromSuperview() // Remove the temporary view
        
        return croppedImage
    }
}

extension PhotoCropViewController: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
        
        updateContentSize()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
}
