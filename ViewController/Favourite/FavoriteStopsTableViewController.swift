//
//  FavoriteStopsTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/27/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import UIKit

class FavoriteStopsTableViewController: UITableViewController
{
    private var myFavoriteStopsList:[Stops] = [Stops]()
    private let headerview = UIView()
    private var headerLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.headerLabel.adjustsFontSizeToFitWidth = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "Favorites"
        self.tableView.separatorColor = UIColor.clear
        
        if traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        if traitCollection.forceTouchCapability == .available{
            
            registerForPreviewing(with: self, sourceView: tableView)
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(UserDefaults.standard.object(forKey: "StopDefaults") != nil)
        {
            let StopData =  UserDefaults.standard.object(forKey: "StopDefaults") as! Data
            myFavoriteStopsList = NSKeyedUnarchiver.unarchiveObject(with: StopData) as! [Stops]
        }
        
//        FavouriteStopsGlobalData.sharedInstance.MyFavouriteStops = myFavoriteStopsList
        
        tableView.reloadData()
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        self.performSegue(withIdentifier: "showFavoriteRoutes", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView?
    {
        headerview.backgroundColor = UIColor.clear
        
        headerview.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        headerview.layer.masksToBounds = false
        headerview.layer.cornerRadius = 5.0
        headerview.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        headerLabel.text =  "Stops"
        headerLabel.frame = CGRect(x:10,y:0, width: view.frame.width - 16, height: 30)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFavoriteStopsList.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let stop = myFavoriteStopsList[indexPath.row]
        
        FavouriteStopsGlobalData.sharedInstance.selectedStops.stoplat = stop.stoplat
        FavouriteStopsGlobalData.sharedInstance.selectedStops.stoplng = stop.stoplng
        FavouriteStopsGlobalData.sharedInstance.selectedStops.stopnumber = stop.stopnumber
        FavouriteStopsGlobalData.sharedInstance.selectedStops.stoptitle = stop.stoptitle
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteStopsCell", for: indexPath) as! FavoriteStopsTableViewCell
        
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 4, y: 12, width: self.view.frame.size.width - 6, height: 55))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        

        if (!myFavoriteStopsList.isEmpty){


            cell.stop = myFavoriteStopsList[indexPath.row]

            return cell

        }
        else
        {
            return cell
        }
    }
    
    @IBAction func ShowInfoView(_ sender: UIBarButtonItem)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        
        newViewController.modalPresentationStyle = .overFullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}



extension FavoriteStopsTableViewController : UIViewControllerPreviewingDelegate
{
    // peak
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteStopsTableViewCell
            else{return nil}
        
        let identifier = "FavoriteStopPredictionTableViewController"
        
        guard let StopsVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? FavoriteStopPredictionTableViewController else {return nil}
        
        StopsVC.StopData = cell.stop
        
        previewingContext.sourceRect = cell.frame
        
        
        return StopsVC
    }
    
    //pop
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
    }
    
    
    
}
