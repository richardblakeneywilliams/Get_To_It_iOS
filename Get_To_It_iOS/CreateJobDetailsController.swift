//
//  CreateJobDetailsController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 14/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseStorage

class CreateJobDetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    
    var catArray = [UIImage]()
    var storage: FIRStorage! //Need to add shit here.
    
    
    @IBOutlet weak var takePicsCat: UICollectionView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var openCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        storage = FIRStorage.storage()
        
        openCameraButton.backgroundColor = nil
        descriptionTextView.layer.cornerRadius = 6
        let realLightGrey:UIColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        descriptionTextView.layer.borderColor = realLightGrey.cgColor
        descriptionTextView.layer.borderWidth = 1
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromJobDetailToLocation" {
            CurrentJob.instance?.description = descriptionTextView.text as String?
            CurrentJob.instance?.subCategory = subCategoryTextField.text as String?
            CurrentJob.instance?.title = jobTitleTextField.text as String?
        }
    }
    

    

    
    @IBAction func openCameraButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Chose a photo source", message: "", preferredStyle: .actionSheet)
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                let noCamAlert = UIAlertController(title: "No Camera Available!", message: "", preferredStyle: .alert)
                let cancelNoCam: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                noCamAlert.addAction(cancelNoCam)
                self.present(noCamAlert, animated: true, completion: nil)
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let pickFromAlbumAction: UIAlertAction = UIAlertAction(title: "Chose from existing photos", style: .default){ (action:UIAlertAction!) in
            imagePicker.sourceType = .photoLibrary
            OperationQueue.main.addOperation({() -> Void in
                self.present(imagePicker, animated: true, completion: nil)
                
            })
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in }
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(pickFromAlbumAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func backNavBarAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextNavBatAction(_ sender: AnyObject) {
        if let title = jobTitleTextField.text, let subCat = subCategoryTextField.text, let desc = descriptionTextView.text{
            performSegue(withIdentifier: "FromJobDetailToLocation", sender: self)
        } else {
            print("No memes for you")
            print(CurrentJob.instance?.title)
        }
    }
    
    
    // MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get local file URLs
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let imageData = UIImagePNGRepresentation(image)!
        
        // Get a reference to the location where we'll store our photos
        let photosRef = storage.reference().child("jobPhotos")
        
        // Get a reference to store the file at jobPhotos/<FILENAME>
        let photoRef = photosRef.child("\(UUID().uuidString).png")
        
        // Upload file to Firebase Storage
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        photoRef.put(imageData, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            //let url = snapshot.metadata?.downloadURL()?.absoluteString
            // Set the download URL to the message box, so that the user can send it to the database
            
        }


        
        
        catArray.append(image)
        takePicsCat.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = takePicsCat.dequeueReusableCell(withReuseIdentifier: "addedPhotoCell", for: indexPath) as! addedPhotoPreviewCell
        cell.image?.image = self.catArray[(indexPath as NSIndexPath).row]
        return cell
    }
}




