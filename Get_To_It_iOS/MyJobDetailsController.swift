//
//  MyJobDetailsController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 9/08/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class MyJobDetailsController: ButtonBarPagerTabStripViewController {
    
    
    @IBOutlet weak var shadowView: UIView!
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)

    override func viewDidLoad() {
        
        
        navigationItem.title = "Mow Lawns"
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .whiteColor()
        settings.style.buttonBarItemBackgroundColor = .whiteColor()
        settings.style.selectedBarBackgroundColor = blueInstagramColor
        settings.style.buttonBarItemFont = .boldSystemFontOfSize(14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blackColor()
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .blackColor()
            newCell?.label.textColor = self?.blueInstagramColor
        }
        super.viewDidLoad()
    }
    
    
    
    override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        //let child_1 = OverviewViewController(itemInfo: IndicatorInfo(title: " Overview"))
        let child_2 = DetailsViewController(itemInfo: IndicatorInfo(title: " Details"))
        let child_3 = DetailsViewController(itemInfo: IndicatorInfo(title: " Tasks"))
        let child_4 = DetailsViewController(itemInfo: IndicatorInfo(title: " Location"))
        
        let child_5 = storyboard.instantiateViewControllerWithIdentifier("OverviewViewController")
        

        return [child_5, child_2, child_3, child_4]
    }

}








    
    
    





