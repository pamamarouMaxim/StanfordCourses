//
//  ShowImageViewController.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/12/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController, UIScrollViewDelegate {
  
    var imageUrl: URL? {
        didSet {
            currentImage = nil
        }
    }
    private var currentImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            activityIndicator?.stopAnimating()
        }
    }
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  private var imageView = UIImageView()
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
          scrollView.minimumZoomScale = 0.1
          scrollView.maximumZoomScale = 5.0
          scrollView.delegate = self
          scrollView.addSubview(imageView)
        }
    }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      activityIndicator.startAnimating()
      if let url = imageUrl {
          DispatchQueue.global(qos: .userInteractive).async {
              let responseImage = try? Data.init(contentsOf: url)
              if let imageData = responseImage {
                  DispatchQueue.main.async {
                      if url == self.imageUrl {
                           self.currentImage = UIImage(data: imageData)
                      }
                  }
            }
          }
      }
    }
}
