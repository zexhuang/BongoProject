//
//  RoutePredictionTableViewController.swift
//  Bongo
//
//  Created by Huangzexian on 11/20/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import UIKit

class RoutesPredictionTableViewController: UITableViewController {

    var refresher:UIRefreshControl!
    let headerview = UIView()
    var headerLabel = UILabel()
    var headerLabelSubtitle = UILabel()
    var stopsInfoList = [StopsInfo]()
    let routePredictionGlobalData:Stops = RoutePredictionGlobalData.sharedInstance.routePrediction
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        
        // Configure the cells for the table
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.separatorColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionHeaderHeight = 70
        
        
        // Add support for pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string:"Pull to Refresh")
        refresher.addTarget(self, action: #selector(StopPredictionTableViewController.populate), for: UIControlEvents.valueChanged)
        
        // self-update 15 second intervals
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(StopPredictionTableViewController.update), userInfo: nil, repeats: true)
        
        
        tableView.addSubview(refresher)
        tableView.reloadData()
        
        
        
        // Set up the URL request
        let todoEndpoint: String = "http://api.ebongo.org/prediction?stopid=" +  routePredictionGlobalData.stopnumber! + "&api_key=XXXX"
        
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
                    self.stopsInfoList =  StopsInfo.downloadBongoStopsInfo(jsonDictionary: todo!)
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
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        headerLabel.text = routePredictionGlobalData.stoptitle
        headerLabelSubtitle.text = routePredictionGlobalData.stopnumber
        
        
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.stopsInfoList.count == 0){
            
            return 1
        }
        else{
            return stopsInfoList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutesPredictionCell", for: indexPath) as! RoutesPredictionTableViewCell
        
        if (stopsInfoList.count == 0){
            
            let stopInfo:StopsInfo = StopsInfo()
            
            stopInfo.RouteName = "No Buses Running"
            stopInfo.Agency = "No Agency Running"
            stopInfo.Prediction = 999
            
            cell.stopsInfo = stopInfo
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 4, y: 12, width: self.view.frame.size.width - 6, height: 55))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
            
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
            return cell
            
        }
        else{
            let stopInfo = stopsInfoList[indexPath.row]
            
            cell.stopsInfo = stopInfo
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 4, y: 12, width: self.view.frame.size.width - 6, height: 55))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
            
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
            return cell
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView?
    {
        headerview.backgroundColor = UIColor.clear
        
        headerview.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])
        
        headerview.layer.masksToBounds = false
        headerview.layer.cornerRadius = 5.0
        headerview.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //let titleLabel = UILabel()
        headerLabel.text =  routePredictionGlobalData.stoptitle
        headerLabel.frame = CGRect(x:10,y:5, width: view.frame.width, height: 30)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerview.addSubview(headerLabel)
        
        ///let NumberLabel = UILabel()
        
        headerLabelSubtitle.text =  "Stop " + routePredictionGlobalData.stopnumber!
        headerLabelSubtitle.frame = CGRect(x:10,y:35, width: view.frame.width, height: 30)
        headerLabelSubtitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        headerview.addSubview(headerLabelSubtitle)
        
        
        return headerview
    }
    
    
    @objc func populate()
    {
        let todoEndpoint: String = "http://api.ebongo.org/prediction?stopid=" + routePredictionGlobalData.stopnumber! + "&api_key=XXXX"
        
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
                    self.stopsInfoList =  StopsInfo.downloadBongoStopsInfo(jsonDictionary: todo!)
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
            }.resume()
        
        
        refresher.endRefreshing()
        tableView.reloadData()
    }
    
    @objc func update() {
        // Set up the URL request
        let todoEndpoint: String = "http://api.ebongo.org/prediction?stopid=" +  routePredictionGlobalData.stopnumber! + "&api_key=XXXX"
        
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
                    self.stopsInfoList =  StopsInfo.downloadBongoStopsInfo(jsonDictionary: todo!)
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
    

}
