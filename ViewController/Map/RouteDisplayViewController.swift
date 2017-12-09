//
//  RouteDisplayViewController.swift
//  Bongo
//
//  Created by Brian Schweer on 12/8/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit
import MapKit

class RouteDisplayViewController : UIViewController
{
    @IBOutlet var walkToStopLabel: UILabel!
    @IBOutlet var busRouteLabel: UILabel!
    @IBOutlet var walkFromStopLabel: UILabel!
    
    private var walkToStopText: String = "Error"
    private var busRouteText: String = "Error"
    private var walkFromStopText: String = "Error"
    
    var startStop: Stops!
    var destinationStop: Stops!
    var currentLocation: CLLocation!
    var mapView: MKMapView?
    
    public func setVCData(walkToStopText: String, busRouteText: String, walkFromStopText: String, startStop: Stops, destinationStop: Stops, currentLocation: CLLocation, mapView: MKMapView)
    {
        self.walkToStopText = walkToStopText
        self.busRouteText = busRouteText
        self.walkFromStopText = walkFromStopText
        
        self.startStop = startStop
        self.destinationStop = destinationStop
        self.currentLocation = currentLocation
        self.mapView = mapView
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.walkFromStopLabel.text = walkToStopText
        self.busRouteLabel.text = busRouteText
        self.walkFromStopLabel.text = walkFromStopText
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.blue
        polylineRenderer.lineWidth = 8
        return polylineRenderer
    }
    
    @IBAction func walkToStopButtonPressed()
    {
        
    }
    
    @IBAction func busRouteButtonPressed()
    {
        
    }
    
    
    @IBAction func walkFromStopButtonPressed()
    {
        
    }
    
}
