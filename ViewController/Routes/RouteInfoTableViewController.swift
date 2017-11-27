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
    var stops = [Stops]()
    
    var isFavoriteButtonPressed = false
    
    let FavoriteButtonStatus = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.removeObject(forKey: "ButtonStatus")
//        UserDefaults.standard.synchronize()
        
        
        // favourite button
        let favouriteButtonItem = UIBarButtonItem.init(image: UIImage(named: "like"), style: .done, target: self, action: #selector(pushToFavourite))
        
        self.navigationItem.rightBarButtonItem = favouriteButtonItem
        
        
        
        isFavoriteButtonPressed = UserDefaults.standard.bool(forKey: "ButtonStatus")
        
        if (isFavoriteButtonPressed == true){
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
        }
        else{
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
        
        
        
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
        
            
            isFavoriteButtonPressed = UserDefaults.standard.bool(forKey: "ButtonStatus")
        
        if (isFavoriteButtonPressed == true){
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
        }
        else{
                  self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
            
        print("isFavoriteButtonPressed" + "\(isFavoriteButtonPressed)")
            
        tableView.reloadData()
        
    }
    
    @objc func pushToFavourite() {
        
        
        if (isFavoriteButtonPressed == false){
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.98, green:0.22, blue:0.35, alpha:1.0)
            print("is favorite!")


            let encodedData = NSKeyedArchiver.archivedData(withRootObject: routeglobalData)

            let FavoriteRoutesDefault = UserDefaults.standard
            
            FavoriteRoutesDefault.set(encodedData, forKey: "RouteDefaults")

            FavoriteRoutesDefault.synchronize()
            
            
            
            isFavoriteButtonPressed = true
        
            FavoriteButtonStatus.set(isFavoriteButtonPressed, forKey: "ButtonStatus")
            
            FavoriteButtonStatus.synchronize()
            
 
        }
        else{
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            print("is not favorite!")
            
            isFavoriteButtonPressed = false
            
            FavoriteButtonStatus.set(isFavoriteButtonPressed, forKey: "ButtonStatus")
            
            FavoriteButtonStatus.synchronize()
        }
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
    

}
