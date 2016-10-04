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
    

    override func viewDidLoad() {
        
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = catCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CreateJobPhotoCell
        
        cell.imageView?.image = self.imageArray[(indexPath as NSIndexPath).row]
        cell.label?.text = self.names[(indexPath as NSIndexPath).row]
    
        //Round the edges
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0).cgColor
        cell.layer.borderWidth = 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        
        CurrentJob.instance!.category = self.names[(indexPath as NSIndexPath).row] as String?

    }

}
