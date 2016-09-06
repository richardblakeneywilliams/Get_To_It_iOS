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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
