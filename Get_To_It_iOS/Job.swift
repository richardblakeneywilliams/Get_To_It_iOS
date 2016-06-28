//
//  Job.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 17/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation

class Job{
    
        var title: NSString?
        var description: NSString?
        var category: NSString?
        var subCategory: NSString?
        var long: Double?
        var lat: Double?
        var numberOfHours: Int?
        var jobStartTime: NSDate?
        var jobEndTime: NSDate?
        var toolsOnSite: Bool?
        var areTheyPresent: Bool?
    
    init(title: NSString, description: NSString, category: NSString, subCategory: NSString, long: Double, lat: Double,
         numberOfHours: Int, jobStartTime: NSDate, jobEndTime: NSDate, toolsOnSite: Bool, areTheyPresent: Bool){
        self.title = title
        self.description = description
        self.category = category
        self.subCategory = subCategory
        self.long = long
        self.lat = lat
        self.numberOfHours = numberOfHours
        self.jobStartTime = jobStartTime
        self.jobEndTime = jobEndTime
        self.toolsOnSite = toolsOnSite
        self.areTheyPresent = areTheyPresent
    }
    
    init(){
//        self.title = ""
//        self.description = ""
//        self.category = ""
//        self.subCategory = ""
//        self.long = 0.0
//        self.lat = 0.0
//        self.numberOfHours = 0
//        self.jobStartTime = NSDate()
//        self.jobEndTime = NSDate()
//        self.toolsOnSite = true
//        self.areTheyPresent = true
    }
    
    
}