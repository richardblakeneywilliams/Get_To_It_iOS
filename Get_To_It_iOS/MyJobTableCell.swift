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
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var startTimeHour: UILabel!
    @IBOutlet weak var startTimeMonth: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundVIew.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).CGColor
        backgroundVIew.layer.borderWidth = 1.5
        backgroundVIew.layer.cornerRadius = 8
        mapView.layer.cornerRadius = 8

        // Initialization code
        bringSubviewToFront(categoryLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
