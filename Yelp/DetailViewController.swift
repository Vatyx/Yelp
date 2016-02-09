//
//  DetailViewController.swift
//  Yelp
//
//  Created by Vatyx on 2/8/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var business : Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessName.text = business.name
        //map.delegate = self
        setupMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callBusiness(sender: AnyObject) {
        if let url = NSURL(string: "tel://\(business.phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        map.setRegion(region, animated: false)
    }
    
    func setupMap(){
        if let latitude = business.lat?.doubleValue{
            if let longitude = business.long?.doubleValue{
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let regionRadius: CLLocationDistance = 600
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                    regionRadius * 2.0, regionRadius * 2.0)
                map.setRegion(coordinateRegion,animated: true)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                dropPin.title = business.name
                map.addAnnotation(dropPin)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
