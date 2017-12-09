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

    override func viewDidLoad()
    {
        super.viewDidLoad()
   
        self.tableView.reloadData()
        self.navigationItem.title = "Routes"

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        if traitCollection.forceTouchCapability == .available
        {
           registerForPreviewing(with: self, sourceView: tableView)
        }
        
        
        let todoEndpoint: String = "http://api.ebongo.org/routelist?api_key=XXXX"
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
                
                    self.routes = Routes.downloadBongoRoutesFromURL(jsonDictionary: todo!)

            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            
            DispatchQueue.main.async () {
                
                self.tableView.reloadData()
            }
            
        }.resume()
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
        
        let route = routes[indexPath.row]

        cell.route = route
        
        return cell
    }
    

}



extension RoutesTableViewController : UIViewControllerPreviewingDelegate{
    
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? RoutesTableViewCell
            else{return nil}
        
        let identifier = "RouteInfoTableViewController"
        
        guard let RoutesVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? RouteInfoTableViewController else {return nil}
        
        RoutesVC.routeData = cell.route
        
        previewingContext.sourceRect = cell.frame
        
        
        return RoutesVC 
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
    }
    
    
    
}
