//
//  Extensions.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 9/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        let config = URLSessionConfiguration.default //Session Configuration
        let session = URLSession(configuration: config) //Load configuration into session
        let url = URL(string: urlString)
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error)
            } else {
                DispatchQueue.main.async {
                    if let downloadImage = UIImage(data: data!){
                        imageCache.setObject(downloadImage, forKey: urlString as NSString)
                        self.image = downloadImage
                    }
                }
            }
        }
        task.resume()
    }
    
}

extension UIButton {
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}





