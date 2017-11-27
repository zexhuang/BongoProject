//
//  TripPlanning.swift
//  Bongo
//
//  Created by Brian Schweer on 11/25/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit
import MapKit

class TripPlanning
{
    // This is currently n^2 just to get it to work. Speed improvements to come soon
    public static func determineIfBusGoesToBothStops(startingStops: [Stops], destinationStops: [Stops])->[Stops : Stops]
    {
        var retval = [Stops : Stops]()
        for startStop in startingStops
        {
            for destStop in destinationStops
            {
                if determineIfBusGoesToBothStops(start: startStop, destination: destStop)
                {
                    retval[startStop] = destStop
                    return retval
                }
            }
        }
        return retval
    }
    
    private static func determineIfBusGoesToBothStops(start: Stops, destination: Stops)->Bool
    {
        let predictionsForStart: [StopsInfo]! = getPredictionForStop(stop: start)
        if predictionsForStart == nil || predictionsForStart.isEmpty
        {
            return false
        }
        
        let predictionsForDestination: [StopsInfo]! = getPredictionForStop(stop: destination)
        if predictionsForDestination == nil || predictionsForDestination.isEmpty
        {
            return false
        }
        
        let routesFromStartingStop = NSMutableSet()
        for prediction in predictionsForStart
        {
            routesFromStartingStop.add(prediction.RouteName!)
        }
                
        let commonRoutes = NSMutableSet()
        for prediction in predictionsForDestination
        {
            if routesFromStartingStop.contains(prediction.RouteName!)
            {
                commonRoutes.add(prediction.RouteName!)
            }
        }
        
        print("Common routes:")
        for route in commonRoutes
        {
            print(route)
        }
        
        return commonRoutes.count > 0 
    }
    
    private static func getPredictionForStop(stop: Stops)->[StopsInfo]!
    {
        // Set up the URL request
        let todoEndpoint: String = "http://api.ebongo.org/prediction?stopid=" +  stop.stopnumber!  + "&api_key=XXXX"
        
        var result: [StopsInfo]! = nil
        
        guard let url = URL(string: todoEndpoint) else { return nil }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url)
        {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
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

                result = StopsInfo.downloadBongoStopsInfo(jsonDictionary: todo!)
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
        
        // Wait for result to be populated
        var count: Int = 0
        while(result == nil && count < 100)
        {
            count += 1
            usleep(50000)
        }
        
        return result
    }
}
