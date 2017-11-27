//
//  StopsTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 10/20/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class StopsTableViewController: UITableViewController
{
    var stops = [Stops]()
    
    var filteredStops = [Stops]()
    let searchController = UISearchController(searchResultsController: nil)
    let globalDataStopToModify = StopsGlobalData.sharedInstance.selectedStops
 

    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Stops"
        searchController.searchBar.barTintColor = UIColor.clear
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.navigationItem.title = "Stops"
        
        stops = Stops.downloadBongoStops()
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStops = stops.filter({( myStop : Stops) -> Bool in
            return (myStop.stoptitle?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
//    @available(iOS 9.0, *)
//    override var previewActionItems: [UIPreviewActionItem] {
//        
//        let item1 = UIPreviewAction(title: "Item1", style: .default) {
//            (action, vc) in
//            // run item 1 action
//        }
//        
//        let item2 = UIPreviewAction(title: "Item2", style: .destructive) {
//            (action, vc) in
//            // run item 2 action
//        }
//        
//        return [item1, item2]
//    }

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
        if isFiltering(){
            
            return filteredStops.count
            
        }
        
        return stops.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        
        
        if isFiltering()
        {
            let stop = filteredStops[indexPath.row]
           
            globalDataStopToModify.stoptitle = stop.stoptitle!
            globalDataStopToModify.stopnumber = stop.stopnumber!
            globalDataStopToModify.stoplat = stop.stoplat!
            globalDataStopToModify.stoplng = stop.stoplng!
        }
        else
        {
            let stop = stops[indexPath.row]
            globalDataStopToModify.stoptitle = stop.stoptitle!
            globalDataStopToModify.stopnumber = stop.stopnumber!
            globalDataStopToModify.stoplat = stop.stoplat!
            globalDataStopToModify.stoplng = stop.stoplng!
        }
        
        
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Stopscell", for: indexPath) as! StopsTableViewCell
        
        if isFiltering() {
            
            let stop = filteredStops[indexPath.row]
            
            cell.stop = stop
            
        }
        else{
            
             let stop = stops[indexPath.row]
            
            cell.stop = stop
        }
        
        return cell

    }
    


}

extension StopsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension StopsTableViewController : UIViewControllerPreviewingDelegate{
    
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.showDetailViewController(viewControllerToCommit, sender: self)
    }

    
    
}


