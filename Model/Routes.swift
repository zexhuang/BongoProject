//
//  Routes.swift
//  Bongo
//
//  Created by Huangzexian on 10/20/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation

class Routes: NSObject, NSCoding
{
    var id: Int?
    var name: String?
    var tag: String?
    var agency:String?
    var agencyName:String?
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(tag, forKey: "tag")
        aCoder.encode(agency, forKey: "agency")
        aCoder.encode(agencyName, forKey: "agencyName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        tag = aDecoder.decodeObject(forKey: "tag") as? String
        agency = aDecoder.decodeObject(forKey: "agency") as? String
        agencyName = aDecoder.decodeObject(forKey: "agencyName") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int ?? aDecoder.decodeInteger(forKey: "id")
    }
    
    
    override init()
    {
        self.id = 0
        self.name = " "
        self.tag = " "
        self.agency = " "
        self.agencyName = " " 

    }
    
    
    init(id: Int, name: String,tag: String,agency:String,agencyName:String)
    {
        self.id = id
        self.name = name
        self.tag = tag
        self.agency = agency
        self.agencyName = agencyName
    }
    
    init(routeInfomation:[String: AnyObject])
    {
        self.id = routeInfomation["id"] as? Int
        self.name = routeInfomation["name"] as? String
        self.tag =  routeInfomation["tag"] as? String
        self.agency =  routeInfomation["agency"] as? String
        self.agencyName =  routeInfomation["agencyname"] as? String
    }
    
    static func downloadBongoRoutesFromURL(jsonDictionary:[String:AnyObject])->[Routes]
    {
        var routes = [Routes]()
       
        let routesDictionaries = jsonDictionary["routes"]as![[String:AnyObject]]
            
            for routeDictionary in routesDictionaries
            {
                let routeInfomation = routeDictionary["route"]as! [String : Any]
                let newRoute = Routes(routeInfomation: routeInfomation as [String : AnyObject])
                
                routes.append(newRoute)
            }
        
        return routes
    }
    
    
    private static var allRoutes = [Routes]()

    static func downloadBongoRoutes()->[Routes]
    {
        if allRoutes.count > 0
        {
            return allRoutes
        }
        
        let jsonFile = Bundle.main.path(forResource: "routelist", ofType:"json")
        let jsonFileURL = URL (fileURLWithPath: jsonFile!)
        let jsonData = try?Data(contentsOf: jsonFileURL)
        
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData)
        {
            let routesDictionaries = jsonDictionary["routes"] as! [[String:AnyObject]]

            for routeDictionary in routesDictionaries
            {
                let routeInfomation = routeDictionary["route"] as! [String : Any]
                let newRoute = Routes(routeInfomation: routeInfomation as [String : AnyObject])
        
                allRoutes.append(newRoute)
            }
        }
         
        return allRoutes
    }
}
