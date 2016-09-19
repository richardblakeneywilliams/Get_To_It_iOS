//
//  OverviewEureka.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 19/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka

class OverviewEureka: FormViewController {
    
    override func viewDidLoad() {
        
        form +++
        
        Section()
            
            
            <<< DateTimeInlineRow("Start Time") {
                $0.title = $0.tag
                $0.value = NSDate()
            }
        
                <<< IntRow("Hours"){
                    $0.title = $0.tag
                    $0.baseValue = 5
                    $0.disabled = true

                    }
        
            <<< SwitchRow("Multi-Day Job:"){
                $0.baseValue = false
                
            }
        
        
    }
    
    
}
