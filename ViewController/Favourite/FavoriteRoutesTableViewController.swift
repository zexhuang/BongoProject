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
        
        navigationItem.title = "Favorites"
        self.tableView.separatorColor = UIColor.clear
        
        UserDefaults.standard.removeObject(forKey: "ListDefaults")
        UserDefaults.standard.removeObject(forKey: "RouteDefaults")
        UserDefaults.standard.synchronize()
        

        if(UserDefaults.standard.object(forKey: "ListDefaults") != nil){
            
            let userDefault  = UserDefaults.standard.object(forKey: "ListDefaults") as! Data
            
            myFavoriteRoutesList = NSKeyedUnarchiver.unarchiveObject(with: userDefault) as! [Routes]
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        count = 0
        
        if(UserDefaults.standard.object(forKey: "RouteDefaults") != nil){

            let FavoriteRoutesDefault  = UserDefaults.standard.object(forKey: "RouteDefaults") as! Data

            myFavoriteRoutes = NSKeyedUnarchiver.unarchiveObject(with: FavoriteRoutesDefault) as! Routes
            
            if (myFavoriteRoutesList.count == 0)
                {
                
                myFavoriteRoutesList.append(myFavoriteRoutes)
                
                let encodedList = NSKeyedArchiver.archivedData(withRootObject: myFavoriteRoutesList)
                
                let FavoriteRoutesListDefault = UserDefaults.standard
                
                FavoriteRoutesListDefault.set(encodedList, forKey: "ListDefaults")
                
                FavoriteRoutesListDefault.synchronize()
                
            }
            else
            {
                for i in(0...myFavoriteRoutesList.count - 1){
                    
                    if (myFavoriteRoutes.name == myFavoriteRoutesList[i].name){

                        count = count + 1
                    }
                }
                
                
                if ( count == 0){
                    
                    myFavoriteRoutesList.append(myFavoriteRoutes)
                    
                    let encodedList = NSKeyedArchiver.archivedData(withRootObject: myFavoriteRoutesList)
                    
                    let FavoriteRoutesListDefault = UserDefaults.standard
                    
                    FavoriteRoutesListDefault.set(encodedList, forKey: "ListDefaults")
                    
                    FavoriteRoutesListDefault.synchronize()
                    
                }
                
                self.tableView.reloadData()
            }
            
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
