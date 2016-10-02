//
//  CurrentJob.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 29/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import Foundation

class CurrentJob: Job {
    static var instance: Job? = Job()
    
    
    func destroy() {
        CurrentJob.instance = nil
    }
}

