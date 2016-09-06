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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        
        //profilePictureView.layer.cornerRadius = 6
        //profilePictureView.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).CGColor
        //profilePictureView.layer.borderWidth = 2
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
