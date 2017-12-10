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
    
    @IBOutlet weak var WalktoStop: UIButton!
    @IBOutlet weak var BusRouteButton: UIButton!
    @IBOutlet weak var StoptoDestination: UIButton!
    
    private var walkToStopText: String = "Error"
    private var busRouteText: String = "Error"
    private var walkFromStopText: String = "Error"
    private var selectedRouteName: String = "Error"
    
    var startStop: Stops!
    var destinationStop: Stops!
    var destinationName: String!
    var startLocation: CLLocation!
    var destinationLocation: CLLocation!
    var mapView: MKMapView?
    
    var mapVC: MapViewController!
    
    public func setVCData(walkToStopText: String, busRouteText: String, walkFromStopText: String, selectedRouteName: String, startStop: Stops, destinationStop: Stops, startLocation: CLLocation, destinationLocation: CLLocation, destinationName: String, mapVC: MapViewController)
    {
        self.walkToStopText = walkToStopText
        self.busRouteText = busRouteText
        self.walkFromStopText = walkFromStopText
        self.selectedRouteName = selectedRouteName
        
        self.startStop = startStop
        self.destinationStop = destinationStop
        self.startLocation = startLocation
        self.destinationLocation = destinationLocation
        self.destinationName = destinationName
        self.mapVC = mapVC
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        
        self.view.backgroundColor = .clear
        self.view.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        self.walkToStopLabel.text = walkToStopText
        self.busRouteLabel.text = busRouteText
        self.walkFromStopLabel.text = walkFromStopText
        
        self.walkToStopLabel.textColor = UIColor(red:0.05, green:0.50, blue:0.82, alpha:1.0)
        self.busRouteLabel.textColor = UIColor(red:0.05, green:0.50, blue:0.82, alpha:1.0)
        self.walkFromStopLabel.textColor = UIColor(red:0.05, green:0.50, blue:0.82, alpha:1.0)
        
        self.walkToStopLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.busRouteLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.walkFromStopLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        self.walkToStopLabel.adjustsFontSizeToFitWidth = true
        self.busRouteLabel.adjustsFontSizeToFitWidth = true
        self.walkFromStopLabel.adjustsFontSizeToFitWidth = true
        
        WalktoStop.layer.shadowColor = UIColor.darkGray.cgColor
        WalktoStop.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        WalktoStop.layer.shadowRadius = 2.0
        WalktoStop.layer.shadowOpacity = 0.7
        
        BusRouteButton.layer.shadowColor = UIColor.darkGray.cgColor
        BusRouteButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        BusRouteButton.layer.shadowRadius = 2.0
        BusRouteButton.layer.shadowOpacity = 0.7
        
        StoptoDestination.layer.shadowColor = UIColor.darkGray.cgColor
        StoptoDestination.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        StoptoDestination.layer.shadowRadius = 2.0
        StoptoDestination.layer.shadowOpacity = 0.7
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.blue
        polylineRenderer.lineWidth = 8
        return polylineRenderer
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func walkToStopButtonPressed()
    {
        self.dismiss(animated: true, completion: {
            let startStopLocation: CLLocation = CLLocation(latitude: (self.startStop.stoplat)!, longitude: (self.startStop.stoplng)!)
            
            self.mapVC.giveWalkingDirections(start: self.startLocation, destination: startStopLocation)
        })
    }
    
    @IBAction func busRouteButtonPressed()
    {
        self.dismiss(animated: true, completion: {
            //let startStopLocation: CLLocation = CLLocation(latitude: (self.startStop.stoplat)!, longitude: (self.startStop.stoplng)!)
            //let destinationStopLocation: CLLocation = CLLocation(latitude: (self.destinationStop.stoplat)!, longitude: (self.destinationStop.stoplng)!)
            
            let selectedStartStop: Stops = self.startStop
            
            let selectedDestinationStop: Stops = self.destinationStop
            
            self.mapVC.giveBusDirectionsOnMap(SelectedStartStop: selectedStartStop, SelectedDestinationStop: selectedDestinationStop, routeName: self.selectedRouteName)
            
           // self.mapVC.giveBusDirectionsOnMap(SelectedStartStop: selectedStartStop, SelectedDestinationStop: selectedDestinationStop, routeName: self.selectedRouteName)
        })
    }
    
  
    @IBAction func walkFromStopButtonPressed()
    {
        self.dismiss(animated: true, completion: {
            
            let destinationStopLocation: CLLocation = CLLocation(latitude: (self.destinationStop.stoplat)!, longitude: (self.destinationStop.stoplng)!)
            
            self.mapVC.giveWalkingDirections(start: destinationStopLocation, destination: self.destinationLocation)
        })
    }
    
    
    @IBAction func doneButtonPressed()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
