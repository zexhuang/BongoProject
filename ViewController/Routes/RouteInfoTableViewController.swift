//
//  RouteInfoTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/7/17.
//  Copyright © 2017 Huangzexian. All rights reserved.

import UIKit
import MapKit

class RouteInfoTableViewController: UITableViewController,MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var theMap: MKMapView!
    
    let routePredictionGlobalData:Stops = RoutePredictionGlobalData.sharedInstance.routePrediction
    var routeData = RouteGlobalData.sharedInstance.routeData
    
    var stops = [Stops]()
    var RouteSubList = [Routes]()
    var favoriteRouteList = [Routes]()
    
    var annotations = [MKPointAnnotation]()
    var coordinates: [CLLocationCoordinate2D] = []
    private var locationManager = CLLocationManager()
    
    var isFavoriteButtonPressed = false
    var RouteisExisted = false
    
    let FavoriteRoutesDefault = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        let favouriteButtonItem = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(pushToFavourite))
        
        self.navigationItem.rightBarButtonItem = favouriteButtonItem

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        navigationItem.title = routeData.name
        
        self.theMap.delegate = self
        self.theMap.mapType = MKMapType.standard

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager = CLLocationManager()

     
    }
    
    let regionRadius: CLLocationDistance = 4000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        theMap.setRegion(coordinateRegion, animated: true)
    }

    
    override func viewWillAppear(_ animated: Bool)
    {

        
        if(FavoriteRoutesDefault.object(forKey: "RouteDefaults") != nil )
        {
            let favoriteRouteData =  FavoriteRoutesDefault.object(forKey: "RouteDefaults") as! Data
            
            favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
            
            for i in favoriteRouteList
            {
                if (i.id == routeData.id){
                    
                    RouteisExisted = true
                }
                
                if (RouteisExisted){
                    
                    isFavoriteButtonPressed = true
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
                }
                    
                else{
                    
                    isFavoriteButtonPressed = false
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                    
                }
            }
            
        }
        
        let todoEndpoint: String = "http://api.ebongo.org/route?agency=\( routeData.agency!)&route=\(routeData.id!)&api_key=XXXX"
        guard let url = URL(string: todoEndpoint) else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        session.dataTask(with: url){
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
                
                DispatchQueue.main.async() {
                    self.stops =  Stops.parseBongoStopsfromURL(jsonDictionary: todo!)
                    
                    self.theMap.addAnnotations(self.showAllStops(stopEntrylist:self.stops) )
                    
                    self.showRoute(stopEntrylist:self.stops)
                    
                    let initialLocation = CLLocation(latitude:              Stops.parseBongoRouteCoordinatefromURL(jsonDictionary: todo!)[0], longitude:              Stops.parseBongoRouteCoordinatefromURL(jsonDictionary: todo!)[1])
                    
                    self.centerMapOnLocation(location: initialLocation)
                    
                    Stops.parseBongoPathfromURL(jsonDictionary: todo!)
                    
                    self.tableView.reloadData()
                }
              
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            
            
            }.resume()
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        
        self.theMap.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(hue: 0.6056, saturation: 0.61, brightness: 0.69, alpha: 1.0)
        renderer.lineWidth = 3
        
        return renderer
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            
            routePredictionGlobalData.stoptitle = ((view.annotation?.title)!)!
            routePredictionGlobalData.stopnumber = ((view.annotation?.subtitle)!)!
            
            //performSegue(withIdentifier: "routePinToPredictions", sender: self)
        }
    }
    
    
    func showAllStops(stopEntrylist:[Stops]) -> [MKPointAnnotation]{
        
        for stopEntry in stopEntrylist {
            
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: stopEntry.stoplat!, longitude: stopEntry.stoplng!)
            newAnnotation.title = stopEntry.stoptitle
            newAnnotation.subtitle = stopEntry.stopnumber
            annotations.append(newAnnotation)
            
        }
        return annotations
    }
    
    func showRoute(stopEntrylist:[Stops]) {
        
        for stopEntry in stopEntrylist {
            
            coordinates.append(CLLocationCoordinate2D(latitude: stopEntry.stoplat!, longitude: stopEntry.stoplng!))
        }
        let stopPolyLine = MKPolyline(coordinates: &self.coordinates, count: self.coordinates.count)
        self.theMap.add(stopPolyLine,level: MKOverlayLevel.aboveLabels)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        

        return stops.count
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let stop = stops[indexPath.row]
        
        routePredictionGlobalData.stoptitle = stop.stoptitle!
        routePredictionGlobalData.stopnumber = stop.stopnumber!
        routePredictionGlobalData.stoplat = stop.stoplat!
        routePredictionGlobalData.stoplng = stop.stoplng!
        
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteInfoCell", for: indexPath)as! RouteInfoTableViewCell

        let stop = stops[indexPath.row]
        cell.stop = stop
        
        return cell
    }
    

    
    @objc func pushToFavourite() {
        
        
        if (isFavoriteButtonPressed == false){
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
            
            print("is favorite!")
            
            
            if(FavoriteRoutesDefault.object(forKey: "RouteDefaults") != nil ){
                
                let favoriteRouteData =  FavoriteRoutesDefault.object(forKey: "RouteDefaults") as! Data
                
                favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
                
                favoriteRouteList.append(routeData)
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
                
                FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
                
                FavoriteRoutesDefault.synchronize()
                
            }
            
            else{
                
                favoriteRouteList.append(routeData)

                let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
                
                FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
                
                FavoriteRoutesDefault.synchronize()
                
            }
            
            isFavoriteButtonPressed = true
            
        }
        else{
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            print("is not favorite!")
            
            let favoriteRouteData =  FavoriteRoutesDefault.object(forKey: "RouteDefaults") as! Data
            
            var favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
            
            for i in favoriteRouteList {
                
                if (i.id != routeData.id){

                    
                    RouteSubList.append(i)
                    
                }
            }
            
            favoriteRouteList = RouteSubList
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
            
            FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
            
            FavoriteRoutesDefault.synchronize()
            
            isFavoriteButtonPressed = false
            
        }
    }

    
}
