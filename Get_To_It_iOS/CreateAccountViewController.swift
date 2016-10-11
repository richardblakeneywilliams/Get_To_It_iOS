//
//  CreateAccountViewController.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 4/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var behindButtonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addProfilePicButton: UIButton!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var workPlaceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        addProfilePicButton.alignImageAndTitleVertically()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createAccountAction(_ sender: AnyObject) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text, let firstName = self.firstNameField.text, let profilePic = self.picImageView.image,
            let workPlace = self.workPlaceTextField.text, let lastName = self.lastNameField.text {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    //TODO: Something went wrong with the sign in. We should do something here
                    print(error.localizedDescription)
                    
                    return
                } else {
                    UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    
                    let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(user!.uid)")
                    
                    if let uploadData = UIImagePNGRepresentation(profilePic){
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print(error)
                                return
                            } else {
                                if let profileImageUrl = metadata?.downloadURL(){
                                    registerUserIntoDatabaseWithUID(uid: (user?.uid)!, firstName: firstName, lastName: lastName, email: email, profileUrl: profileImageUrl.absoluteString, workPlace: workPlace)
                                }
                            }
                        })
                    }
                }
            }
        self.dismiss(animated: true,completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: ImagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addProfilePicPressed(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //Hide the button
        addProfilePicButton.isHidden = true
        
        //Add the image
        picImageView.image = image
        picImageView.layer.cornerRadius = 50
        picImageView.layer.masksToBounds = true
        picImageView.contentMode = .scaleAspectFill

        
        dismiss(animated: true, completion: nil)

    }
    


    

}
