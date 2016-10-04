//
//  MyJobsDetailsViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 2/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
import XLPagerTabStrip

class MyJobsDetailsViewController: FormViewController, IndicatorInfoProvider {
    
    var infoInfo: IndicatorInfo = "Details"
    
    init(itemInfo: IndicatorInfo) {
        self.infoInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return infoInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            form =
                
                Section("Job Time")
                
                <<< DateTimeInlineRow("Job Start Time") {
                    $0.title = $0.tag
                    $0.value = Date().addingTimeInterval(60*60*24)

        
                }
                
                <<< DateTimeInlineRow("Job End Time"){
                    $0.title = $0.tag
                    $0.value = Date().addingTimeInterval(60*60*25)
                }
                
                
                <<< IntRow(){
                    $0.title = "Hours per day"
                    $0.tag = $0.title
                    $0.value = 5
                    }
                
                <<< IntRow(){
                    $0.title = "Total Hours"
                    $0.tag = $0.title
                    $0.value = 5
                }
                
                +++
                
                Section("Extras")
                
                <<< IntRow(){
                    $0.title = "Number of workers needed"
                    $0.tag = $0.title
                    $0.value = 1
                }
        
                <<< SwitchRow(){
                    $0.title = "Will Employer Be On Site"
                    $0.tag = $0.title
                    $0.value = true
                }
                
                <<< SwitchRow(){
                    $0.title = "Will There Be Tools On Site"
                    $0.tag = $0.title
                    $0.value = true
                }
        
                +++
                
                Section("Gear Required To Bring")
                
                <<< TextAreaRow("Gear Required To Bring"){
                  $0.title = "Gear Required To Bring"
                  $0.tag = $0.title
                  $0.value = "Because alot of this work is going to reuqire de-weeding, it'd be great if you could brind a pair of thick gloves"
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
