//
//  Category.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 23/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class Category {
    var name: NSString
    var image: UIImage
    
    
    required init(name: NSString, image: UIImage){
        self.name = name
        self.image = image
    }
}