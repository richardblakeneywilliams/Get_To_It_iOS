//
//  User.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 17/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation

struct User {
    
    let isEmployer: Bool //I don't even think I need this
    let isWorker: Bool
    let name: String
    let uid: String
    let isSignedIn: Bool //Do I really need this? Investigate
    let profilePicture: NSURL //I want to cache this on the device as well as in the cloud. By default this is their fb pic. If email sign up, ask for it.
    
    //let location:
    
    
    
    
}