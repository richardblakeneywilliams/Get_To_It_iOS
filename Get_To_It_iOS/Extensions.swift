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
