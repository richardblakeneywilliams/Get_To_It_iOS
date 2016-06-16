//
//  CreateJobDetailsController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 14/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class CreateJobDetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var categorySelected = String()
    //var catArray = [UIImage]()
    
    var catArray = [UIImage(named: "Gardening_test"), UIImage(named: "Manual Labour")]
    
    var cameraOption = 0
    
    @IBOutlet weak var takePicsCat: UICollectionView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        descriptionTextView.layer.cornerRadius = 6
        
        let realLightGrey:UIColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        
        descriptionTextView.layer.borderColor = realLightGrey.CGColor
        descriptionTextView.layer.borderWidth = 1
        
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Chose a photo source", message: "", preferredStyle: .ActionSheet)
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (action:UIAlertAction!) in
            imagePicker.sourceType = .Camera
            NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            })
            
        }
        
        let pickFromAlbumAction: UIAlertAction = UIAlertAction(title: "Chose from existing photos", style: .Default){ (action:UIAlertAction!) in
            imagePicker.sourceType = .PhotoLibrary
            NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in }
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(pickFromAlbumAction)
        alertController.addAction(cancelAction)
        
        takePicsCat.hidden = false
        
        self.presentViewController(alertController, animated: true, completion:nil)
        
    }
    
    
    @IBAction func backNavBarAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func nextNavBatAction(sender: AnyObject) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //grab image from lib/camera
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        catArray.append(image)
        takePicsCat.reloadData()
        dismissViewControllerAnimated(false, completion: nil)

    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("MEMES1")
        return self.catArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("MEMES2")
        let cell = takePicsCat.dequeueReusableCellWithReuseIdentifier("addedPhotoPreviewCell", forIndexPath: indexPath) as! addedPhotoPreviewCell
        cell.image?.image = self.catArray[indexPath.row]
        cell.backgroundColor = UIColor.lightTextColor()
        return cell
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
