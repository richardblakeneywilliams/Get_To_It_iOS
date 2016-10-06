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
    
    @IBAction func backNavBar(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func submitJob(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a MMMM dd, yyyy"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.timeZone = NSTimeZone.local
        
        
        if let rowHoursReq = form.rowBy(tag: "Hours Required")?.baseValue {
            CurrentJob.instance?.numberOfHours = rowHoursReq as? Int
        } else {
            print("Hours Required Not Entered")
        }
        
        if let rowTotalCost = form.rowBy(tag: "Total Cost")?.baseValue {
            CurrentJob.instance?.totalCost = rowTotalCost as? Double
        } else {
            print("RowTotalCost not calucated")
        }
        
        //TODO: Look at all day job.
        if let rowAllDay = form.rowBy(tag: "All-day")?.baseValue {
            print(rowAllDay)
        } else {
            print("Row All Day")
        }
        
        if let rowJobStartTime = form.rowBy(tag: "Job Start Time")?.baseValue{
            
            //NSDate Stored as Timestamp
            let startInterval = (rowJobStartTime as? Date)!.timeIntervalSince1970
            
            CurrentJob.instance?.jobStartTime = startInterval
        } else {
            print("No Start Time Entered")
        }
        
        if let rowJobEndTime = form.rowBy(tag: "Job End Time")?.baseValue {
            
            //NSDate Stored as Timestamp
            let endInterval = (rowJobEndTime as? Date)!.timeIntervalSince1970
            
            CurrentJob.instance?.jobEndTime = endInterval
        } else {
            print("No Job End Time Entered")
        }
        
        if let rowTools = form.rowBy(tag: "Tools for the Job On-Site")?.baseValue {
            CurrentJob.instance?.toolsOnSite = rowTools as? Bool
        } else {
            print("No row tools enter")
        }
        if let rowPresent = form.rowBy(tag: "Will you be present?")?.baseValue {
            CurrentJob.instance?.areTheyPresent = rowPresent as? Bool
        } else {
            print("No are you present entered")
        }
        
        let viewController: MainTabViewController = (storyboard!.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    
   func showAlert() {
        let alertController = UIAlertController(title: "Only 1 hour mate...", message: "Come on mate, is it really worth their time for one hour? You can make their day and get alot more done with two", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            
            Section(header: "Enter Hours to work out cost", footer: "Calculated using our flat rate of $\(pricePerHour)0 per hour")
            
            <<< IntRow("Hours Required") {
                $0.title = $0.tag
                $0.placeholder = "Enter Here"
            }.onChange({ (IntRow) in
                let decimalRow = self.form.rowBy(tag: "Total Cost")
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
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                $0.disabled = true
            }
            
            +++
            
            SwitchRow("All-day") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Job Start Time")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Job End Time")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .medium
                        startDate.dateFormatter?.timeStyle = .none
                        endDate.dateFormatter?.dateStyle = .medium
                        endDate.dateFormatter?.timeStyle = .none
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .short
                        startDate.dateFormatter?.timeStyle = .short
                        endDate.dateFormatter?.dateStyle = .short
                        endDate.dateFormatter?.timeStyle = .short
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Job Start Time") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Job End Time")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
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
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Job Start Time")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
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
                    saveNewJob()
                })
        
    }
}

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
}



