//
//  Stops.swift
//  Bongo
//
//  Created by Huangzexian on 10/22/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation

class Stops: NSObject, NSCoding
{
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(stoptitle, forKey: "stoptitle")
        aCoder.encode(stopnumber, forKey: "stopnumber")
        aCoder.encode(stoplat, forKey: "stoplat")
        aCoder.encode(stoplng, forKey: "stoplng")

    }
    
    required init?(coder aDecoder: NSCoder) {
        stoptitle = aDecoder.decodeObject(forKey: "stoptitle") as? String
        stopnumber = aDecoder.decodeObject(forKey: "stopnumber") as? String
        stoplat = aDecoder.decodeObject(forKey: "stoplat") as? Double ?? aDecoder.decodeDouble(forKey: "stoplat")
        stoplng = aDecoder.decodeObject(forKey: "stoplng") as? Double ?? aDecoder.decodeDouble(forKey: "stoplng")
        //id = aDecoder.decodeObject(forKey: "id") as? Int ?? aDecoder.decodeInteger(forKey: "id")
    }
    
    override var hashValue: Int
    {
        return stoplat!.hashValue ^ stoplng!.hashValue &* 16777619
    }
    
    static func ==(lhs: Stops, rhs: Stops) -> Bool
    {
        return lhs.stoplat == rhs.stoplat && lhs.stoplng == rhs.stoplng
    }
    
    private static var allStops = [Stops]()
    
    var stopnumber :String?
    var stoptitle : String?
    var stoplat: Double?
    var stoplng: Double?
    
    
    
    override init()
    {
        self.stoptitle = ""
        self.stopnumber = ""
        self.stoplat = 0
        self.stoplng = 0
    }
    
    init(stopnumber :String, stoptitle : String, stoplat: Double, stoplng: Double )
    {
        self.stoptitle = stoptitle
        self.stopnumber = stopnumber
        self.stoplat = stoplat
        self.stoplng = stoplng
    }
    
    init(stopInfomation:[String: AnyObject])
    {
        self.stoptitle = stopInfomation["stoptitle"] as? String
        self.stopnumber = stopInfomation["stopnumber"] as? String
        self.stoplat =  stopInfomation["stoplat"] as? Double
        self.stoplng = stopInfomation["stoplng"] as? Double
    }
    
    public static func parseBongoStopsfromURL(jsonDictionary:[String:AnyObject])->[Stops]{
        
        var stopList = [Stops]()
        
        let jsonDictionaries = jsonDictionary["route"] as![String:AnyObject]
        
        let stopsDictionaries = jsonDictionaries["directions"] as![[String:AnyObject]]
        
        for stopsDictionary in stopsDictionaries
        {
            let stopCollection = stopsDictionary["stops"] as! [[String:AnyObject]]
            
            for stopInfomation in stopCollection{
                
                let newStop = Stops(stopInfomation:stopInfomation as [String : AnyObject])
                stopList.append(newStop)
                
            }

        }
        
        return stopList
    }
    
    
    public static func parseBongoRouteCoordinatefromURL(jsonDictionary:[String:AnyObject])->[Double]{
        
        var RouteCoordinate = [Double]()
        
         let jsonDictionaries = jsonDictionary["route"] as![String:AnyObject]
    
        let maxlng = jsonDictionaries["min_lng"] as! NSNumber
        let maxlat = jsonDictionaries["min_lat"] as! NSNumber
        
        RouteCoordinate.append(maxlat.doubleValue)
        RouteCoordinate.append(maxlng.doubleValue)
        
        return RouteCoordinate
    }
    
    public static func downloadBongoStops() -> [Stops]
    {
        // If the data has already been downloaded, simply return allStops
        if allStops.count > 0
        {
            return allStops
        }
        
        let jsonFile = Bundle.main.path(forResource: "stoplist", ofType:"json")
        let jsonFileURL = URL (fileURLWithPath: jsonFile!)
        let jsonData = try?Data(contentsOf: jsonFileURL)
        

        if let jasonDictionary = NetworkService.parseJSONFromData(jsonData){
            
           
            let stopsDictionaries = jasonDictionary["stops"]as![[String:AnyObject]]
            
            for stopDictionary in stopsDictionaries{
                
                let stopInfomation = stopDictionary["stop"]as! [String : Any]
                
                let newStop = Stops(stopInfomation:stopInfomation as [String : AnyObject])
                
                allStops.append(newStop)
            }
        }

        return allStops
    }
}
