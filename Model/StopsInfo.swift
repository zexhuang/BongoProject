//
//  StopsInfo.swift
//  Bongo
//
//  Created by Huangzexian on 10/31/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation

class StopsInfo
{
    var Prediction: Int?
    var RouteName: String?
    var Agency: String?
    var optionalInfo: Int? = 0
    
    init()
    {
        self.Prediction = 0
        self.RouteName = " "
        self.Agency = " "
    }
    
    
    init(Prediction:Int, RouteName:String, Agency:String)
    {
        self.Prediction = Prediction
        self.RouteName = RouteName
        self.Agency = Agency
    }
    
    init(prediction:[String:AnyObject])
    {
        self.Agency = prediction["agency"] as? String
        self.Prediction = prediction["minutes"] as? Int
        self.RouteName = prediction["title"] as? String
    }
    
    
    public static func downloadBongoStopsInfo(jsonDictionary:[String:AnyObject], optionalInfo: Int) -> [StopsInfo]
    {
        var stopsInfo = [StopsInfo]()
        let jsonDictionaries = jsonDictionary["predictions"] as![[String:AnyObject]]
        
        for predictionDictionary in jsonDictionaries
        {
            let prediction = predictionDictionary
            let newPrediction = StopsInfo(prediction:prediction as [String:AnyObject])
            newPrediction.optionalInfo = optionalInfo
            stopsInfo.append(newPrediction)
        }
        return stopsInfo
    }

    
    public static func downloadBongoStopsInfo(jsonDictionary:[String:AnyObject]) -> [StopsInfo]
    {
        return downloadBongoStopsInfo(jsonDictionary: jsonDictionary, optionalInfo: 0)
    }
}
