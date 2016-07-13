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
import SwiftDate


let FIREBASE_REF = FIRDatabase.database().reference()

public func saveJob() {
    
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
    

    if let id = FIRAuth.auth()?.currentUser?.uid{
        uid = id
    } else {
        //Do something here
    }
    
 
    
    
    
    let key = FIREBASE_REF.child("job").childByAutoId().key
 
    let job : [NSObject: AnyObject] =
            ["uid": uid,
               "title": title!,
               "description": description!,
               "category": category!,
               "subCategory": subCategory!,
               "longitute": long!,
               "latitude": lat!,
               "numberOfHours": numberOfHours!,
               "jobStartTime": jobStartTime!,
               "jobEndTime": jobEndTime!,
               "toolsOnSite": toolsOnSite!,
               "areTheyPresent": areTheyPresent!,
               "address": address!,
               "totalCost": totalCost!]
    
    let childUpdates = ["/job/\(key)":job, "/user-jobs/\(uid)/\(key)/": job]
    
    FIREBASE_REF.updateChildValues(childUpdates)
}