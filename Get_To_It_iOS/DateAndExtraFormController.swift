//
//  DateAndExtraFormController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 28/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
import FirebaseDatabase

class DateAndExtraFormController: FormViewController {
    
    let pricePerHour = 20.00
    
    
    let ref = FIRDatabase.database().reference()
    
    @IBAction func backNavBar(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func submitJob(){
        
        if let cat = CurrentJob.instance!.category{
            print(cat)
        } else {
            print("No Category")
        }
        
        if let rowHoursReq = form.rowByTag("Hours Required")?.baseValue {
            print(rowHoursReq)
            CurrentJob.instance?.numberOfHours = rowHoursReq as? Int
        } else {
            print("Hours Required Not Entered")
        }
        
        if let rowTotalCost = form.rowByTag("Total Cost")?.baseValue {
            print(rowTotalCost)
            CurrentJob.instance?.totalCost = rowTotalCost as? Double
        } else {
            print("RowTotalCost not calucated")
        }
        
        //TODO: Look at all day job.
        if let rowAllDay = form.rowByTag("All-day")?.baseValue {
            print(rowAllDay)
        } else {
            print("Row All Day")
        }
        
        if let rowJobStartTime = form.rowByTag("Job Start Time")?.baseValue{
            
            let formatter = NSDateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss zzz")
            formatter.timeZone = NSTimeZone(abbreviation: "NZST") //this is an issue.
            let stringStart = formatter.stringFromDate((rowJobStartTime as? NSDate)!)
            
            print(stringStart)
            
            CurrentJob.instance?.jobStartTime = stringStart as String
        } else {
            print("No Start Time Entered")
        }
        
        if let rowJobEndTime = form.rowByTag("Job End Time")?.baseValue {
            
            let formatter = NSDateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss zzz")
            formatter.locale = NSLocale(localeIdentifier: "el_NZ")
            formatter.timeZone = NSTimeZone(abbreviation: "NZST") //this is an issue.
            
            
            let stringEnd = formatter.stringFromDate((rowJobEndTime as? NSDate)!)

            print(stringEnd)
            
            CurrentJob.instance?.jobEndTime = stringEnd as String

        } else {
            print("No Job End Time Entered")
        }
        
        if let rowTools = form.rowByTag("Tools for the Job On-Site")?.baseValue {
            print(rowTools)
            CurrentJob.instance?.toolsOnSite = rowTools as? Bool
        } else {
            print("No row tools enter")
        }
        if let rowPresent = form.rowByTag("Will you be present?")?.baseValue {
            print(rowPresent)
            CurrentJob.instance?.areTheyPresent = rowPresent as? Bool
        } else {
            print("No are you present entered")
        }
        if let des = CurrentJob.instance?.description {
            print(des)
        } else {
            print("No title for job entered")
        }
        
        if let subCat = CurrentJob.instance?.subCategory{
            print(subCat)
        } else {
            print("No sub Category entered")
        }
        
        if let des = CurrentJob.instance?.description{
            print(des)
        } else {
            print("No description entered")
        }
        

        
    }
    
    
   func showAlert() {
        let alertController = UIAlertController(title: "Only 1 hour mate...", message: "Come on mate, is it really worth their time for one hour? You can make their day and get alot more done with two", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            
            Section(header: "Enter Hours to work out cost", footer: "Calculated using our flat rate of $\(pricePerHour)0 per hour")
            
            <<< IntRow("Hours Required") {
                $0.title = $0.tag
                $0.placeholder = "Enter Here"
            }.onChange({ (IntRow) in
                let decimalRow = self.form.rowByTag("Total Cost")
                var once: Bool = false
                
                if once != true {
                    if IntRow.value == 1  {
                        self.showAlert()
                        decimalRow?.baseValue = Double(IntRow.value!)*self.pricePerHour
                        decimalRow?.disabled
                        decimalRow?.updateCell()
                        once = true
                    } else if IntRow.value != nil {
                        decimalRow?.baseValue = Double(IntRow.value!)*self.pricePerHour
                        decimalRow?.disabled
                        decimalRow?.updateCell()
                        once = true
                    } else {
                        decimalRow?.baseValue = 0.0
                        decimalRow?.disabled
                        decimalRow?.updateCell()
                        once = true
                    }
                    once = true
                }
                once = true

            })
            
        
            <<< DecimalRow("Total Cost") {
                $0.title = $0.tag
                let formatter = CurrencyFormatter()
                formatter.locale = .currentLocale()
                formatter.numberStyle = .CurrencyStyle
                $0.formatter = formatter
                $0.disabled = true
            }
            
            +++
            
            SwitchRow("All-day") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowByTag("Job Start Time")
                    let endDate: DateTimeInlineRow! = self?.form.rowByTag("Job End Time")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .MediumStyle
                        startDate.dateFormatter?.timeStyle = .NoStyle
                        endDate.dateFormatter?.dateStyle = .MediumStyle
                        endDate.dateFormatter?.timeStyle = .NoStyle
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .ShortStyle
                        startDate.dateFormatter?.timeStyle = .ShortStyle
                        endDate.dateFormatter?.dateStyle = .ShortStyle
                        endDate.dateFormatter?.timeStyle = .ShortStyle
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Job Start Time") {
                $0.title = $0.tag
                $0.value = NSDate().dateByAddingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Job End Time")
                    if row.value?.compare(endRow.value!) == .OrderedDescending {
                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                        endRow.cell!.backgroundColor = .whiteColor()
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowByTag("All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .Date
                        }
                        else {
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Job End Time"){
                $0.title = $0.tag
                $0.value = NSDate().dateByAddingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowByTag("Job Start Time")
                    if row.value?.compare(startRow.value!) == .OrderedAscending {
                        row.cell!.backgroundColor = .redColor()
                    }
                    else{
                        row.cell!.backgroundColor = .whiteColor()
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowByTag("All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .Date
                        }
                        else {
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
        
            +++
            
            Section()
        
                <<< SwitchRow("Tools for the Job On-Site"){
                        $0.title = $0.tag
                        $0.value = true
                    }
        
                <<< SwitchRow("Will you be present?"){
                        $0.title = $0.tag
                        $0.value = true
                }
        
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Submit Job"
                }  .onCellSelection({ (cell, row) in
                    self.submitJob()
                    saveJob()
                })
        


        
    }
}

class CurrencyFormatter : NSNumberFormatter, FormatterProtocol {
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        guard obj != nil else { return false }
        let str = string.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        obj.memory = NSNumber(double: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        return true
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.positionFromPosition(position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
    
    
}


