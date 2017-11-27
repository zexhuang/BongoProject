//
//  RoutesTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 10/20/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController
{
    var routes = [Routes]()
    let routeglobalData = RouteGlobalData.sharedInstance.routeData

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        routes = Routes.downloadBongoRoutes()
        
   
        self.tableView.reloadData()
        self.navigationItem.title = "Routes"

        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routes.count
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        
        let route = routes[indexPath.row]
        routeglobalData.name = route.name!
        routeglobalData.agency = route.agency!
        routeglobalData.id =  route.id!
        routeglobalData.agencyName = route.agencyName!
        routeglobalData.tag = route.tag!
        
        return indexPath
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Routecell", for: indexPath)as! RoutesTableViewCell
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 4, y: 12, width: self.view.frame.size.width - 6, height: 55))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)

        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        
        let route = routes[indexPath.row]
            //print("\(routes)")
        cell.route = route
        
        return cell
    }
    

}
