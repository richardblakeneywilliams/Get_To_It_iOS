//
//  DateAndExtraFormController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 28/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka

class DateAndExtraFormController: FormViewController {
    
    let pricePerHour = 20.00
    
    
    @IBAction func backNavBar(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func showAlert() {
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
                $0.placeholder = "Enter Here"
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
                        $0.title = "Tools for the Job On-Site"
                        $0.value = true
                    }
        
                <<< SwitchRow("Will you be present?"){
                        $0.title = "Will you be present?"
                        $0.value = true
                }
        
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Submit Job"
                }  .onCellSelection({ (cell, row) in
                    print("Did it")
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


