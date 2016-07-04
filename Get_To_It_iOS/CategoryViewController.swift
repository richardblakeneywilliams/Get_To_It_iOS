//
//  CategoryViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 29/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import ChameleonFramework



class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var catCollectionView: UICollectionView!
    
    let themeColour = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0)
    
    var segueID = "SelectCategorySegue"


    let names = ["Gardening", "Manual Labour", "Tech Support", "Babysitting", "Delivery", "Food Prep", "Homecare", "Cleaning", "Admin/PA", "Petcare", "Event Help", "Other"]
    
    let imageArray = [UIImage(named: "Gardening_test"), UIImage(named: "Manual Labour"), UIImage(named: "Tech Support"), UIImage(named: "Babysitting"), UIImage(named: "Delivery"), UIImage(named: "Food Prep"), UIImage(named: "Homecare"), UIImage(named: "Cleaning"), UIImage(named: "Admin"), UIImage(named: "Pet Care"),UIImage(named: "Event Help") ,UIImage(named: "Other Question Mark")]
    
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        continueButton.layer.cornerRadius = 8
        //continueButton.backgroundColor = ComplementaryFlatColorOf(themeColour)
    }
    
    // MARK: - Table view data source

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = catCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CreateJobPhotoCell
        
        cell.imageView?.image = self.imageArray[indexPath.row]
        cell.label?.text = self.names[indexPath.row]
    
        //Round the edges
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).CGColor
        cell.layer.borderWidth = 2
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier(segueID, sender: self.navigationController)
        
        CurrentJob.instance!.category = self.names[indexPath.row]
        print(CurrentJob.instance!.category)
    }
    
    
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == segueID{
//            let indexPaths = self.catCollectionView!.indexPathsForSelectedItems()!
//            let indexPath = indexPaths[0] as NSIndexPath
//            
//            //Saves to CurrentJob that is a Singleton.
//            CurrentJob.instance.category = self.names[indexPath.row]
//            print(CurrentJob.instance.category = self.names[indexPath.row])
//        }
//    }
    
    

}
