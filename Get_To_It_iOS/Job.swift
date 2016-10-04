//
//  Job.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 17/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation

class Job{
    
        var uid: String?
        var title: String?
        var description: String?
        var category: String?
        var subCategory: String?
        var address: String?
        var long: Double?
        var lat: Double?
        var numberOfHours: Int?
        var jobStartTime: String?
        var jobEndTime: String?
        var toolsOnSite: Bool?
        var areTheyPresent: Bool?
        var totalCost: Double?
        var status: String?
    
        //var jobCreatorProfilePicture: UI
    
    init(){
        
    }
    
    
    
    init(title: String, description: String, category: String, subCategory: String, address: String, long: Double, lat: Double, numberOfHours: Int, jobStartTime: String, jobEndTime: String, toolsOnSite: Bool, areTheyPresent: Bool, totalCost: Double, status: String, uid: String) {
        
        self.title = title
        self.description = description
        self.category = category
        self.subCategory = subCategory
        self.address = address
        self.long = long
        self.lat = lat
        self.jobEndTime = jobEndTime
        self.jobStartTime = jobStartTime
        self.numberOfHours = numberOfHours
        self.toolsOnSite = toolsOnSite
        self.areTheyPresent = areTheyPresent
        self.totalCost = totalCost
        self.status = status
        self.uid = uid
    }
    
}
