//
//  OverviewViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class OverviewViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //This will need to start empty. 
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
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
//        photoArray.append(UIImage(named: "GardenExample")!)
//        photoArray.append(UIImage(named: "OvenExample")!)
    }
    
    // MARK: - IndicatorInfoProvider
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    // MARK: CollectionView Data Source Info. This is where the photoArray will be filled up when the view is loaded.
    
    
    
    // MARK: CollectionView Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print("lol wtf")
        
        //Use a diff cell
        let cell = photoCollectionView.dequeueReusableCellWithReuseIdentifier("overviewVcCell", forIndexPath: indexPath) as! OverviewVcCell
        cell.imageView?.image = self.photoArray[indexPath.row]
        
        return cell
    }
    
    
}
