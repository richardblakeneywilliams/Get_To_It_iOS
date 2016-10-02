//
//  OverviewViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import HCSStarRatingView


class OverviewViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var declineJobButton: UIButton!
    @IBOutlet weak var acceptJobButton: UIButton!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var multidayLabel: UILabel!
    
    @IBOutlet weak var jobDetailsTextView: UITextView!
    
    //This will need to start empty. TODO: For testing this can stay with just these.
    var photoArray = [UIImage(named: "GardenExample"),UIImage(named: "OvenExample")]
    
    var itemInfo: IndicatorInfo = "Overview"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView Delegate and Datasource
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        //Set up buttons TODO: Add Segue to this that hides these
//        acceptJobButton.layer.cornerRadius = 3
//        declineJobButton.layer.cornerRadius = 3
        
        //Set up profile picture view. TODO: Add Firebase
        profilePicImageView.image = UIImage(named: "DefaultProfilePic")
        profilePicImageView.layer.cornerRadius = 37.5
        profilePicImageView.layer.masksToBounds = true
        
    }
    
    func getInfoForJob(){
        
        
        
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    // MARK: CollectionView Data Source Info. This is where the photoArray will be filled up when the view is loaded. Firebase Storage will be probably fucked with here. 
    
    // MARK: CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "overviewVcCell", for: indexPath) as! OverviewVcCell
        
        cell.imageView?.image = self.photoArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
}

extension CALayer {
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
    
    




