//
//  ViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 2/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import XLPagerTabStrip



class MyJobsLocationViewController: UIViewController, IndicatorInfoProvider {
    
    var infoInfo: IndicatorInfo = "Location"
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
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
    
    //TODO: Add getting the location from Firebase.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: -45.861288, longitude: 170.514819)
        
        
        marker.map = mapView
    
        let camera = GMSCameraPosition.camera(withLatitude: -45.861288, longitude: 170.514819, zoom: 18)
        
        mapView.camera = camera
        
        
        // Do any additional setup after loading the view.
        
        
        
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
