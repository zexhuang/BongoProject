//
//  MapViewController.swift
//  Bongo
//
//  Created by Huangzexian on 10/22/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit
import MapKit


protocol HandleMapSearch
{
    func resultSelected(destination: String)
    func planTrip(destinationLocation: CLLocation)
}


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch
{
    @IBOutlet var theMap: MKMapView!
    private var locationManager = CLLocationManager()

    
    @IBOutlet var overviewButton: UIButton!
    @IBOutlet var nearbyStopButton: UIButton!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    private var destinationToOpenInMaps: CLLocation!
    private var annotations = [MKPointAnnotation]()
    private var resultSearchController:UISearchController? = nil
    private var nameOfDestination: String!
    
    private var routingVC: RouteDisplayViewController!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Map"

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.mapView = theMap
        locationSearchTable.handleMapSearchDelegate = self

        // Configure the top search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter Destination"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        getDirectionsButton.layer.cornerRadius = 10
        getDirectionsButton.clipsToBounds = true
        getDirectionsButton.isHidden = true
        
        overviewButton.layer.cornerRadius = 10
        overviewButton.clipsToBounds = true
        overviewButton.isHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        theMap.delegate = self
        theMap.mapType = MKMapType.standard
        
        // Configure nearby stop button
        nearbyStopButton.isHidden = true
        nearbyStopButton.layer.cornerRadius = 15
        nearbyStopButton.layer.shadowColor = UIColor.darkGray.cgColor
        nearbyStopButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        nearbyStopButton.layer.shadowRadius = 2.0
        nearbyStopButton.layer.shadowOpacity = 0.7
        nearbyStopButton.layer.masksToBounds = false
        
        // Configure current location button
        currentLocationButton.isHidden = true
        currentLocationButton.layer.cornerRadius = 15
        currentLocationButton.layer.shadowColor = UIColor.darkGray.cgColor
        currentLocationButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        currentLocationButton.layer.shadowRadius = 2.0
        currentLocationButton.layer.shadowOpacity = 0.7
        currentLocationButton.layer.masksToBounds = false
    
        
        // If we haven't received permission to access location, ask for it
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            theMap.showsUserLocation = true
            
            let location: CLLocation = locationManager.location!
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.theMap.setRegion(region, animated: true)
            
            nearbyStopButton.isHidden = false
            currentLocationButton.isHidden = false
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if CLLocationManager.locationServicesEnabled() && status == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            theMap.showsUserLocation = true
            
            let location: CLLocation = locationManager.location!
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
            self.theMap.setRegion(region, animated: true)
            
            nearbyStopButton.isHidden = false
            currentLocationButton.isHidden = false
        }
        else
        {
            // We don't have access to the user's location, display a message telling user to
            // enable location services if they want to use location based features
            nearbyStopButton.isHidden = true
            currentLocationButton.isHidden = true
            getDirectionsButton.isHidden = true
            theMap.removeAnnotations(annotations)
            resultSelected(destination: "")
            for overlay in theMap.overlays
            {
                theMap.remove(overlay)
            }
            
            let alert = UIAlertController(title: "Enable Location Services", message: "To access trip planning and nearby stop features, please enable location services.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Automatically called when location was updated
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        
        self.theMap.setRegion(region, animated: true)
    }
    
    
    @IBAction func showNearbyStops()
    {
        let closestStops = getClosestStops(location: locationManager.location!, searchRadius: 400)

        // Get rid of all old annotations
        self.centerMapOnCurrentLocation()
        
        for stopEntry in closestStops
        {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: stopEntry.stoplat!, longitude: stopEntry.stoplng!)
            newAnnotation.title = stopEntry.stoptitle
            newAnnotation.subtitle = stopEntry.stopnumber
            annotations.append(newAnnotation)
        }
        
        self.theMap.addAnnotations(annotations)
    }
    
    
    
    private func getClosestStops(location: CLLocation, searchRadius: Double)->[Stops]
    {
        // Array of every stop
        let allStops: [Stops] = Stops.downloadBongoStops()
        
        // Dictionary for the closest stops
        var closestStops = [Stops : Double]()
        
        // 1 mile = 1609.34 meters
        let oneMile = 1609.34
        
        for stop in allStops
        {
            let stopLocation = CLLocation(latitude: stop.stoplat!, longitude: stop.stoplng!)
            
            // Distance is measured in meters
            let distance: Double = (location.distance(from: stopLocation).magnitude)
            
            // If the stop is within three miles, it can be considered
            if distance < 3 * oneMile
            {
                // Determine whether all of the closest stops are within a quarter mile
                var allStopsWithinSearchRadius = true
                for closeStop in closestStops
                {
                    if closeStop.value > searchRadius
                    {
                        allStopsWithinSearchRadius = false
                        break
                    }
                }
                
                // Add up to five closest stops and any additional if every stop is within a fifth of a mile of current location
                if distance < searchRadius && allStopsWithinSearchRadius || closestStops.count < 5
                {
                    closestStops[stop] = distance
                }
                else
                {
                    for closeStop in closestStops
                    {
                        if closeStop.value > distance
                        {
                            closestStops[closeStop.key] = nil
                            closestStops[stop] = distance
                            break
                        }
                    }
                }
            }
        }
        
        // Create an array of stops sorted by distance away from the location of interest
        var closestStopsArray: [Stops] = [Stops]()
        var previousMin = 0.0
        for pair in closestStops
        {
            var min: Double = Double.infinity
            var stopToAdd: Stops = pair.key
            for p in closestStops
            {
                if p.value < min && p.value > previousMin
                {
                    min = p.value
                    stopToAdd = p.key
                }
            }
            previousMin = min
            closestStopsArray.append(stopToAdd)
        }

        return closestStopsArray
    }
    
    // Gets the current location and focuses the view on it
    @IBAction func centerMapOnCurrentLocation()
    {
        getDirectionsButton.isHidden = true
        theMap.removeAnnotations(annotations)
        annotations.removeAll()
        let location: CLLocation = locationManager.location!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        self.theMap.setRegion(region, animated: true)
        
        for overlay in theMap.overlays
        {
            theMap.remove(overlay)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            MapGlobalData.sharedInstance.mapPrediction.stoptitle = ((view.annotation?.title)!)!
            MapGlobalData.sharedInstance.mapPrediction.stopnumber = ((view.annotation?.subtitle)!)!
            
            performSegue(withIdentifier: "PinToPredictions", sender: self)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // Don't do anything is the user clicked on the blue dot for current location
        if annotation is MKUserLocation
        {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = theMap.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let infoButton = UIButton(type: UIButtonType.detailDisclosure)
            pinView!.rightCalloutAccessoryView = infoButton as UIView
        }
        else
        {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    private func displayAlertMessage(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func resultSelected(destination: String)
    {
        resultSearchController?.searchBar.text = destination
    }
    
    
    
    
    func planTrip(destinationLocation: CLLocation)
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            centerMapOnCurrentLocation()
            let distanceStartToDestination = locationManager.location?.distance(from: destinationLocation).magnitude
            if distanceStartToDestination! < 550.0
            {
                displayAlertMessage(title: "Trip Information", message: "The best route to " + (resultSearchController?.searchBar.text)! + " is walking.")
                giveWalkingDirections(start: locationManager.location!, destination: destinationLocation)
            }
            else if distanceStartToDestination! < 10000
            {
                giveBusDirections(start: locationManager.location!, destination: destinationLocation)
            }
            else
            {
                let title = "No Trips Available"
                let message = "There are no stops near your location or the specified destination."
                displayAlertMessage(title: title, message: message)
            }
        }
        else
        {
            resultSelected(destination: "") // Clear the search field text
            let title = "Enable Location Services"
            let message = "To access trip planning features, please enable location services."
            displayAlertMessage(title: title, message: message)
        }
    }
    
    
    
    // Given a location, determine which stop is closest to it
    private func findNearestStop(locationToCheck: CLLocation)->Stops?
    {
        let allStops: [Stops] = Stops.downloadBongoStops()
        var closestStop: Stops = allStops[0]
        var shortestDistance: Double = Double.infinity
        
        for stop in allStops
        {
            let stopLocation = CLLocation(latitude: stop.stoplat!, longitude: stop.stoplng!)
            let distance: Double = locationToCheck.distance(from: stopLocation).magnitude
            
            if distance < shortestDistance
            {
                shortestDistance = distance
                closestStop = stop
            }
        }
        
        return shortestDistance < 5000 ? closestStop : nil
    }
    
    
    
    
    func giveWalkingDirections(start: CLLocation, destination: CLLocation)
    {
        getDirectionsButton.isHidden = false
        destinationToOpenInMaps = destination

        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes
            {
                self.theMap.add(route.polyline)
                self.theMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    
    
    
    func giveBusDirectionsOnMap(start: CLLocation, destination: CLLocation)
    {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes
            {
                self.theMap.add(route.polyline)
                self.theMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    
    
    func giveBusDirections(start: CLLocation, destination: CLLocation)
    {
        let stopsNearStart = getClosestStops(location: start, searchRadius: 250)
        let stopsNearDestination = getClosestStops(location: destination, searchRadius: 250)
        
        if !stopsNearStart.isEmpty && !stopsNearDestination.isEmpty
        {
            // Add a loading indicator
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            
            self.present(alert, animated: true, completion: {
                
                self.overviewButton.isHidden = false
                self.centerMapOnCurrentLocation()
                self.nameOfDestination = self.resultSearchController?.searchBar.text
                
                let optimalRouteDictionary: [Stops : String] = TripPlanning.findBestBusBetweenStartAndDestination(startingStops: stopsNearStart, destinationStops: stopsNearDestination)
                
                
                // Remove the loading indicator
                alert.dismiss(animated: true, completion: {
                    if optimalRouteDictionary.count == 2
                    {
                        var startingStop: Stops = stopsNearStart[0]
                        var destinationStop: Stops = stopsNearDestination[0]
                        var walkToStopDescription: String = "An unknown error occurred"
                        var busRouteDescription: String = "An unknown error occurred"
                        var walkFromStopDescription: String = "An unknown error occurred"
                        
                        for pair in optimalRouteDictionary
                        {
                            if pair.value.isEmpty
                            {
                                destinationStop = pair.key
                            }
                            else
                            {
                                startingStop = pair.key
                                busRouteDescription = pair.value
                            }
                        }
                        
                        walkToStopDescription = "Walk to stop: " + startingStop.stoptitle!
                        walkFromStopDescription = "Walk from " + destinationStop.stoptitle! + " to destination"
                        
                        // Create view for displaying all information and present it
                        self.routingVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "routeVC") as! RouteDisplayViewController
                        
                        let destinationName = self.resultSearchController?.searchBar.text
                        
                        self.routingVC.setVCData(walkToStopText: walkToStopDescription, busRouteText: busRouteDescription, walkFromStopText: walkFromStopDescription, startStop: startingStop, destinationStop: destinationStop, startLocation: start, destinationLocation: destination, destinationName: destinationName!, mapVC: self)

                        self.present(self.routingVC, animated: true, completion: nil)
                    }
                    else
                    {
                        self.overviewButton.isHidden = true
                        
                        let title = "No Bus Trips Available"
                        let message = "There are no available buses. Showing walking directions"
                        self.giveWalkingDirections(start: start, destination: destination)
                        self.displayAlertMessage(title: title, message: message)
                    }
                })
            })
        }
        else
        {
            let title = "No Trips Available"
            let message = "There are no stops near your location or the specified destination."
            displayAlertMessage(title: title, message: message)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(hue: 0.6056, saturation: 0.61, brightness: 0.69, alpha: 1.0)
        renderer.lineWidth = 3
        
        return renderer
    }
    
    
    @IBAction func openMapsAppWithDirections()
    {
        let coordinate = CLLocationCoordinate2DMake(destinationToOpenInMaps.coordinate.latitude, destinationToOpenInMaps.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        
        mapItem.name = nameOfDestination
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
    
    
    
    @IBAction func returnToOverviewPressed()
    {
        self.present(routingVC, animated: true, completion: nil)
    }
}


