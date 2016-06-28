//
//  CategoryViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 29/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var catCollectionView: UICollectionView!


    let names = ["Gardening", "Manual Labour", "Tech Support", "Babysitting", "Delivery", "Food Prep", "Homecare", "Cleaning", "Admin/PA", "Petcare", "Other"]
    
    let imageArray = [UIImage(named: "Gardening_test"), UIImage(named: "Manual Labour"), UIImage(named: "Tech Support"), UIImage(named: "Babysitting"), UIImage(named: "Delivery"), UIImage(named: "Food Prep"), UIImage(named: "Homecare"), UIImage(named: "Cleaning"), UIImage(named: "Admin"), UIImage(named: "Pet Care"), UIImage(named: "Other Question Mark")]
    
    override func viewDidLoad() {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = catCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CreateJobPhotoCell
        
        cell.imageView?.image = self.imageArray[indexPath.row]
        cell.label?.text = self.names[indexPath.row]
        
        
        //Round the edges for memes
        cell.layer.cornerRadius = 6
        cell.roundedCornerView.layer.cornerRadius = 6
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails"{
            let indexPaths = self.catCollectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! CreateJobDetailsController
            
            CurrentJob.instance.category = self.names[indexPath.row]
            vc.categorySelected = self.names[indexPath.row]
        }
    }
    
    //MARK: Function for opening and starting new job.
    

}
