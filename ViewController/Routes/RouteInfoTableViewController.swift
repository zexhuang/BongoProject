//
//  RouteInfoTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/7/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class RouteInfoTableViewController: UITableViewController {
    
    let routeglobalData = RouteGlobalData.sharedInstance.routeData
    
    let routePredictionGlobalData:Stops = RoutePredictionGlobalData.sharedInstance.routePrediction
    
    var routeData = Routes()
    
    var stops = [Stops]()
    
    var isFavoriteButtonPressed = false
    var RouteisExisted = false
    var RouteisEqual = false
    
    let FavoriteRoutesDefault = UserDefaults.standard
    
    var RouteSubList = [Routes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let favouriteButtonItem = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(pushToFavourite))
        
        self.navigationItem.rightBarButtonItem = favouriteButtonItem

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        navigationItem.title = routeglobalData.name
        
        
        let todoEndpoint: String = "http://api.ebongo.org/route?agency=\( routeglobalData.agency!)&route=\(routeglobalData.id!)&api_key=XXXX"
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
                
                DispatchQueue.main.async {
                    self.stops =  Stops.parseBongoStopsfromURL(jsonDictionary: todo!)
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
            
         
            }.resume()
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(!FavouriteRoutesGlobalData.sharedInstance.MyFavouriteRoutes.isEmpty){
            
            for i in FavouriteRoutesGlobalData.sharedInstance.MyFavouriteRoutes{
                
                if (i.id == routeglobalData.id){
                    
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
                
                DispatchQueue.main.async {
                    self.stops =  Stops.parseBongoStopsfromURL(jsonDictionary: todo!)
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
            
            
            }.resume()
        
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
                
                var favoriteRouteList = NSKeyedUnarchiver.unarchiveObject(with: favoriteRouteData) as! [Routes]
                

                
                favoriteRouteList.append(routeglobalData)
                
                print(favoriteRouteList[0].name!)
                print(favoriteRouteList.last!.name!)
                print(favoriteRouteList.count)
                
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: favoriteRouteList)
                
                
                FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")
                
                FavoriteRoutesDefault.synchronize()
                
            }
            
            else{
                
                var favoriteRouteList = [Routes]()
                
                favoriteRouteList.append(routeglobalData)
                
                print("Chicken" + favoriteRouteList[0].name!)
                print("Chicken" + favoriteRouteList.last!.name!)
                print(favoriteRouteList.count)
                
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
                
                if (i.id != routeglobalData.id){

                    
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
