//
//  OverviewViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OverviewViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var infoTableView: UITableView!
    
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
        descriptionTextView.layer.cornerRadius = 8
        
        //CollectionView Delegate and Datasource
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        //TableView Delege and Datasource
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        //Code for changing profile Imageview into a circle.
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
    }
    
    // MARK: - IndicatorInfoProvider
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    // MARK: CollectionView Data Source Info. This is where the photoArray will be filled up when the view is loaded. Firebase Storage will be probably fucked with here. 
    
    
    
    // MARK: CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = photoCollectionView.dequeueReusableCellWithReuseIdentifier("overviewVcCell", forIndexPath: indexPath) as! OverviewVcCell
        cell.imageView?.image = self.photoArray[indexPath.row]
        
        return cell
    }
    
    
    
    //MARK: TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabelNames.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = infoTableView.dequeueReusableCellWithIdentifier("overviewTableCell") as! OverViewTableCell
        cell.leftLabel.text = self.leftLabelNames[indexPath.row]
        cell.rightLabel.text = self.rightLabelInfo[indexPath.row]
        return cell
        
        
    }
    
    //MARK: TableView Data Source
    var leftLabelNames = ["Start Time", "Hours", "Multiday Job"]
    
    //TODO: This will be where the cloud hookup grabs info.
    var rightLabelInfo = ["9am 12/1/16", "12", "No"]
    
    
    
    
}
    //MARK: Tableview Cell
class OverViewTableCell: UITableViewCell {
    
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        self.leftLabel.layer.borderWidth = 0.5
        self.leftLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.rightLabel.layer.borderWidth = 0.5
        self.rightLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    
    
}




