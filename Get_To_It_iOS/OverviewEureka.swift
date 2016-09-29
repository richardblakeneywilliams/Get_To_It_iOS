//
//  OverviewEureka.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 19/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
import XLPagerTabStrip

class OverviewEureka: FormViewController, IndicatorInfoProvider {
    
    
    var itemInfo: IndicatorInfo = "Eureka"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - IndicatorInfoProvider
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    override func viewDidLoad() {
        
        form +++
        
        Section()
            
            <<< SwitchRow("Multi-Day Job:"){
                $0.baseValue = false
                
            }
        
        
    }
    
    
}
