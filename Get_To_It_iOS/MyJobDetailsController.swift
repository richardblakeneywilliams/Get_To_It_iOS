//
//  MyJobDetailsController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 9/08/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class MyJobDetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var catName: UILabel!
    
    @IBOutlet weak var employerName: UILabel!
    @IBOutlet weak var employerProfilePic: UIImageView!
    let names = ["Gardening", "Manual Labour"]
    let imageArray = [UIImage(named: "Gardening_test"), UIImage(named: "Manual Labour")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employerProfilePic.layer.cornerRadius = 17
        employerProfilePic.frame = CGRectMake(0, 0, 34, 34)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        employerProfilePic.layer.cornerRadius = 17
        employerProfilePic.frame = CGRectMake(0, 0, 34, 34)
    }
    
    
    
    // MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let cellCount = CGFloat(collectionView.numberOfItemsInSection(section))
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        let totalCellWidth = cellCount * cellWidth
        let totalCellSpacing = cellSpacing * (cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = catCollectionView.dequeueReusableCellWithReuseIdentifier("myjobdetailcell", forIndexPath: indexPath) as! MyJobDetailControllerCell
        
        cell.catLabel?.text = self.names[indexPath.row]
        cell.catPic?.image = self.imageArray[indexPath.row]
        
        print("k")
        
        //Round the edges
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).CGColor
        cell.layer.borderWidth = 2
        
        return cell
    }
    
    
    

}



