//
//  FavoriteStopsTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/27/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import UIKit

class FavoriteStopsTableViewController: UITableViewController {
    
    var myFavoriteStopsList:[Stops] = [Stops]()
    
    let headerview = UIView()
    var headerLabel = UILabel()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        navigationItem.title = "Favorites"
        self.tableView.separatorColor = UIColor.clear

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(UserDefaults.standard.object(forKey: "StopDefaults") != nil){
            
            let StopData =  UserDefaults.standard.object(forKey: "StopDefaults") as! Data
            
            myFavoriteStopsList = NSKeyedUnarchiver.unarchiveObject(with: StopData) as! [Stops]
            
        }
        
//        FavouriteStopsGlobalData.sharedInstance.MyFavouriteStops = myFavoriteStopsList
        
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
        headerLabel.text =  "Stops"
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
        return myFavoriteStopsList.count
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
        else {

            return cell
        }
        
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
