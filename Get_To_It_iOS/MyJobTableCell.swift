//
//  MyJobTableCell.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 1/07/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class MyJobTableCell: UITableViewCell {
    
    
    @IBOutlet weak var CategoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var employerName: UILabel!
    @IBOutlet weak var employerProfilePic: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    //@IBOutlet weak var mapView: GMSMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.cornerRadius = 6
        categoryView.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).CGColor
        categoryView.layer.borderWidth = 2
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
