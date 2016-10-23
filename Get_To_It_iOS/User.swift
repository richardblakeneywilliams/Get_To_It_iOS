//
//  User.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 6/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var uid: String?
    
    //Do I even need this...
    var faceBookVerified: Bool?
    
    var firstName: String?
    var lastName: String?
    var areTheyLegal: Bool?
    var bankAccountNumber: String?
    var occupation: String?
    var workPlace: String?
    var greatestAchievement: String?
    var referees: [String]?
    var profilePictureURL: String?
    var seeJobDistance: Double?
    
    override init () {}
    
    
}
