//
//  DetailsViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 17/09/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DetailsViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XLPagerTabStrip"
        
        let textArea = UITextView()
        
        textArea.translatesAutoresizingMaskIntoConstraints = true
        
        view.addSubview(textArea)
        
        
        
        view.addSubview(label)
        view.backgroundColor = .whiteColor()
        
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -50))
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    
    
}

