//
//  MyJobsTasksViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 2/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
import XLPagerTabStrip

class MyJobsTasksViewController: FormViewController, IndicatorInfoProvider {
    
    var infoInfo: IndicatorInfo = "Tasks"
    
    let tasks = ["Mow lawns", "Put the grass clippings in the bag", "Trim the edges"]

    
    
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
        
        form +++ SelectableSection<ImageCheckRow<String>>("", selectionType: .multipleSelection)
        for option in tasks {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
                }.cellSetup { cell, _ in
                    cell.trueImage = UIImage(named: "selectedRectangle")!
                    cell.falseImage = UIImage(named: "unselectedRectangle")!
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public final class ImageCheckRow<T: Equatable>: Row<ImageCheckCell<T>>, SelectableRowType, RowType {
    public var selectableValue: T?
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class ImageCheckCell<T: Equatable> : Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy public var trueImage: UIImage = {
        return UIImage(named: "selected")!
    }()
    
    lazy public var falseImage: UIImage = {
        return UIImage(named: "unselected")!
    }()
    
    public override func update() {
        super.update()
        accessoryType = .none
        imageView?.image = row.value != nil ? trueImage : falseImage
    }
    
    public override func setup() {
        super.setup()
    }
    
    public override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }
    
}


