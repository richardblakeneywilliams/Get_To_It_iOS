//
//  CreateJobDetailsController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 14/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class CreateJobDetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //need to sart saving these
    var catArray = [UIImage]()
    
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == "CreateJobDetailSegue"{
            CurrentJob.instance.title = jobTitleTextField.text
            CurrentJob.instance.subCategory = subCategoryTextField.text
            CurrentJob.instance.description = descriptionTextView.text
            print(CurrentJob.instance.category)
            print("Just Below Detail FOOL")
        }
    }
        
    @IBAction func nextButton(sender: AnyObject) {
        print("Am I never here")
        self.performSegueWithIdentifier("CreateJobDetailSegue", sender: self)
    }
    

    
    @IBAction func openCameraButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Chose a photo source", message: "", preferredStyle: .ActionSheet)
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                imagePicker.sourceType = .Camera
            } else {
                let noCamAlert = UIAlertController(title: "No Camera Available!", message: "", preferredStyle: .Alert)
                let cancelNoCam: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                noCamAlert.addAction(cancelNoCam)
                self.presentViewController(noCamAlert, animated: true, completion: nil)
            }
            self.presentViewController(imagePicker, animated: true, completion: nil)
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = takePicsCat.dequeueReusableCellWithReuseIdentifier("addedPhotoCell", forIndexPath: indexPath) as! addedPhotoPreviewCell
        cell.image?.image = self.catArray[indexPath.row]
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
