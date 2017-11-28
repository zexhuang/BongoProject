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
    
    let headerview = UIView()
    var headerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.removeObject(forKey: "RouteDefaults")
//        UserDefaults.standard.synchronize()
        
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
    
    override func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView?
    {
        headerview.backgroundColor = UIColor.clear
        
        headerview.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        headerview.layer.masksToBounds = false
        headerview.layer.cornerRadius = 5.0
        headerview.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //let titleLabel = UILabel()
        headerLabel.text =  "Routes"
        headerLabel.frame = CGRect(x:10,y:0, width: view.frame.width, height: 30)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerview.addSubview(headerLabel)
        
        return headerview
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
