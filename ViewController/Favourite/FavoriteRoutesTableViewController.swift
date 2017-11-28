//
//  FavoriteRoutesTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/22/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import UIKit

class FavoriteRoutesTableViewController: UITableViewController {
    
    var myFavoriteRoutesList:[Routes] = [Routes]()
    
    var myFavoriteRoutes:Routes = Routes()
    
    var count:Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        navigationItem.title = "Favorites"
        self.tableView.separatorColor = UIColor.clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.object(forKey: "RouteDefaults") != nil){
            
            let RouteData =  UserDefaults.standard.object(forKey: "RouteDefaults") as! Data
            
            myFavoriteRoutesList = NSKeyedUnarchiver.unarchiveObject(with: RouteData) as! [Routes]
            
        }
        
        FavouriteRoutesGlobalData.sharedInstance.MyFavouriteRoutes = myFavoriteRoutesList
        
        tableView.reloadData()
        
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
      
        
        return myFavoriteRoutesList.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        
        return indexPath
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRoutesCell", for: indexPath) as! FavoriteRoutesTableViewCell

        // Configure the cell...
        
        if (!myFavoriteRoutesList.isEmpty){
            

            cell.route = myFavoriteRoutesList[indexPath.row]
            
            return cell
            
        }
        else {
            
            return cell
        }
        
    }

}
