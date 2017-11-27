//
//  StopsGlobalData.swift
//  Bongo
//
//  Created by Huangzexian on 10/26/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation

class StopsGlobalData {
    
    static let sharedInstance:StopsGlobalData = StopsGlobalData()
    
    /*
    var StopName:String = ""
    var StopNumber:String = ""
    var Stopid:String = ""
    var StopLng:Double = 0.0
    var StopLat:Double = 0.0*/
    
    var selectedStops: Stops = Stops()
}
