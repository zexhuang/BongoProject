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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        headerLabel.adjustsFontSizeToFitWidth = true
        
//        UserDefaults.standard.removeObject(forKey: "RouteDefaults")
//        UserDefaults.standard.synchronize()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "Favorites"
        self.tableView.separatorColor = UIColor.clear
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.object(forKey: "RouteDefaults") != nil)
        {
            
            let RouteData =  UserDefaults.standard.object(forKey: "RouteDefaults") as! Data
            
            myFavoriteRoutesList = NSKeyedUnarchiver.unarchiveObject(with: RouteData) as! [Routes]
            
        }
        
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
        headerLabel.frame = CGRect(x:10,y:0, width: view.frame.width - 16, height: 30)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerview.addSubview(headerLabel)
        
        return headerview
    }


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
        let route = myFavoriteRoutesList[indexPath.row]
        
        FavouriteRoutesGlobalData.sharedInstance.routeData.name = route.name
        FavouriteRoutesGlobalData.sharedInstance.routeData.agency = route.agency
        FavouriteRoutesGlobalData.sharedInstance.routeData.agencyName = route.agencyName
        FavouriteRoutesGlobalData.sharedInstance.routeData.id = route.id
        FavouriteRoutesGlobalData.sharedInstance.routeData.tag = route.tag
        
        return indexPath
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRoutesCell", for: indexPath) as! FavoriteRoutesTableViewCell
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 3, y: 12, width: self.view.frame.size.width - 6, height: 55))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

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

extension FavoriteRoutesTableViewController : UIViewControllerPreviewingDelegate{
    
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteRoutesTableViewCell
            else{return nil}
        
        let identifier = "FavoriteRouteInfoTableViewController"
        
        guard let RoutesVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? FavoriteRouteInfoTableViewController else {return nil}
        
        RoutesVC.routeData = cell.route
        
        previewingContext.sourceRect = cell.frame
        
        
        return RoutesVC
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
    }
    
}





