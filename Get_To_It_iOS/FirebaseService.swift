//
//  FirebaseService.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 4/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


enum Status {
    
    case open
    case pending
    case closed
    case inProgress
    
}


enum locationPrivacy {
    
    case showExactLocation
    case showSuburb
    
}


let FIREBASE_REF = FIRDatabase.database().reference()

//Check if any jobs in the DB.
public func checkForJobs(jobUid uid: String) -> Bool{
    
    
    return true
}


//Function for Changing the Status of a job
public func changeJobStatus(jobUid uid: String){
    
}


//Function for editing an already open job. Just over-writes the whole child.
public func editJob(jobUid uid: String){
    
}

//Function to Save Pictures with Jobs. Saves the picture to Firebase Storage and adds the url of that Picture to the job. 
//Will need to add an array of the pictures to the Job.
// param: uid of the Job to have the pictures added to it. 
// param: pictures: Array of pictures to stored in Firebase and add urls to
public func savePicturesFromCameraToJob(jobUid uid: String, pictures: [NSObject]){
    
}

//Save the image saved. 
// UIImage the best way to do this???
public func saveProfilePictureToFirebase(picture: UIImage){
    
}



//Function for saving jobs to the DB. This is called when the Job is first called. This adds to the user_open
//Also Saves the pictures stored in the CollectionView to Firebase Storage.
public func saveNewJob() {
    
    let title = CurrentJob.instance?.title
    var uid: String = (FIRAuth.auth()?.currentUser?.uid)!
    let address = CurrentJob.instance?.address
    let description = CurrentJob.instance?.description
    let category = CurrentJob.instance?.category
    let subCategory = CurrentJob.instance?.category
    let long = CurrentJob.instance?.long
    let lat = CurrentJob.instance?.lat
    let numberOfHours = CurrentJob.instance?.numberOfHours
    let jobStartTime = CurrentJob.instance?.jobStartTime
    let jobEndTime = CurrentJob.instance?.jobEndTime
    let toolsOnSite = CurrentJob.instance?.toolsOnSite
    let areTheyPresent = CurrentJob.instance?.areTheyPresent
    let totalCost = CurrentJob.instance?.totalCost
    
    let status = "Open"
    
    
    if let id = FIRAuth.auth()?.currentUser?.uid{
        uid = id
    } else {
        //Do something here
    }
    
    let key = FIREBASE_REF.child("job").childByAutoId().key
 
    let job : [AnyHashable: Any] =
            ["uid": uid,
               "title": title!,
               "description": description!,
               "category": category!,
               "subCategory": subCategory!,
               "longitude": long!,
               "latitude": lat!,
               "numberOfHours": numberOfHours!,
               "jobStartTime": jobStartTime!,
               "jobEndTime": jobEndTime!,
               "toolsOnSite": toolsOnSite!,
               "areTheyPresent": areTheyPresent!,
               "address": address!,
               "totalCost": totalCost!,
               "status": status]
    
    let childUpdates = ["/job/\(key)":job, "/user-jobs/\(uid)/\(key)/": job]
    
    FIREBASE_REF.updateChildValues(childUpdates)
}
