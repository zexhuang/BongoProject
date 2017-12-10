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
    public static func findBestBusBetweenStartAndDestination(startingStops: [Stops], destinationStops: [Stops])->[Stops : String]
    {
        var optimalRoute: [Stops : String] = [Stops : String]()
        
        let allPredictionsForStartingStops: [StopsInfo] = getPredictions(stops: startingStops)
        if allPredictionsForStartingStops.isEmpty
        {
            return optimalRoute // Return an empty dictionary
        }
        
        let allPredictionsForDestinationStops: [StopsInfo] = getPredictions(stops: destinationStops)
        if allPredictionsForStartingStops.isEmpty || allPredictionsForDestinationStops.isEmpty
        {
            return optimalRoute // Return an empty dictionary
        }
        
        // Go through the predictions for the starting stop.
        // Store all routes and predictions into a dictionary where
        // the key is the route name and the value is an array of predictions
        var allRoutes = [String : [Int]]()
        for prediction in allPredictionsForStartingStops
        {
            if allRoutes[prediction.RouteName!] == nil
            {
                print("\n\nfound a nil value : \(prediction.RouteName!)")
                allRoutes[prediction.RouteName!] = [Int]()
                allRoutes[prediction.RouteName!]?.append(prediction.optionalInfo!)
                allRoutes[prediction.RouteName!]?.append(prediction.Prediction!)
            }
            else
            {
                let previousPrediction = allRoutes[prediction.RouteName!]![1]
                if prediction.Prediction! < previousPrediction
                {
                    allRoutes[prediction.RouteName!]![0] = prediction.optionalInfo!
                    allRoutes[prediction.RouteName!]![1] = prediction.Prediction!
                }
            }
        }
        
        
        
        for route in allRoutes
        {
            print(route.key + " \(route.value)")
        }
        
        
        
        var minimumPredictionTime: Int = 1000
        for prediction in allPredictionsForDestinationStops
        {
            // The start and destination stops share a common route
            if allRoutes[prediction.RouteName!] != nil
            {
                let timeUntilBusArrivesAtStart = allRoutes[prediction.RouteName!]![1]
                
                print("the time until bus arrives is: \(timeUntilBusArrivesAtStart)")
                
                if prediction.Prediction! > timeUntilBusArrivesAtStart
                {
                    let description: String = "Take " + prediction.RouteName! + " in " + String(timeUntilBusArrivesAtStart) + " minutes."
                    
                    if optimalRoute.count < 2
                    {
                        minimumPredictionTime = timeUntilBusArrivesAtStart
                        optimalRoute[startingStops[allRoutes[prediction.RouteName!]![0]]] = description
                        optimalRoute[destinationStops[prediction.optionalInfo!]] = prediction.RouteName! + "*"
                    }
                    else if minimumPredictionTime < timeUntilBusArrivesAtStart
                    {
                        // Clear existing values and replace with updated values
                        optimalRoute.removeAll()
                        minimumPredictionTime = timeUntilBusArrivesAtStart
                        optimalRoute[startingStops[allRoutes[prediction.RouteName!]![0]]] = description
                        optimalRoute[destinationStops[prediction.optionalInfo!]] = prediction.RouteName! + "*"
                    }
                }
                //allRoutes[prediction.RouteName!] = nil
            }
            else
            {
                print("IN else " + prediction.RouteName! + " " + String(prediction.Prediction!))

            }
        }
        return optimalRoute
    }
    
    // Aggregate all predictions for an array of stops
    private static func getPredictions(stops: [Stops])->[StopsInfo]
    {
        var predictionsForAllStops: [StopsInfo] = [StopsInfo]()
        for i in 0...stops.count-1
        {
            predictionsForAllStops.append(contentsOf: getPredictions(stop: stops[i], stopIndex: i))
        }
        return predictionsForAllStops
    }
    

    
    
    
    
    
    
    /*
    // This is currently n^2 just to get it to work. Speed improvements to come soon
    public static func determineIfBusGoesToBothStops(startingStops: [Stops], destinationStops: [Stops])->[Stops : String]
    {
        var retval = [Stops : Stops]()
        for startStop in startingStops
        {
            for destStop in destinationStops
            {
                if determineIfBusGoesToBothStops(start: startStop, destination: destStop)
                {
                    retval[startStop] = "Take " +
                    retval[destStop] = ""
                    return retval
                }
            }
        }
        return retval
    }
    
    private static func determineIfBusGoesToBothStops(start: Stops, destination: Stops)->Bool
    {
        let predictionsForStart: [StopsInfo]! = getPredictions(stop: start, stopIndex: 0)
        if predictionsForStart == nil || predictionsForStart.isEmpty
        {
            return false
        }
        
        let predictionsForDestination: [StopsInfo]! = getPredictions(stop: destination, stopIndex: 0)
        if predictionsForDestination == nil || predictionsForDestination.isEmpty
        {
            return false
        }
        
        
        // Go through the predictions for the starting stop.
        // Store all routes and predictions into a dictionary where
        // the key is the route name and the value is an array of predictions
        var allRoutes = [String : [Int]]()
        for prediction in predictionsForStart
        {
            if allRoutes[prediction.RouteName!] == nil
            {
                allRoutes[prediction.RouteName!]? = [prediction.Prediction!]
            }
            else
            {
                allRoutes[prediction.RouteName!]?.append(prediction.Prediction!)
            }
        }
        
        
        var minimumPrediction: Int
        for prediction in predictionsForDestination
        {
            if allRoutes[prediction.RouteName!] != nil
            {
                if
            }
        }
        
        
        /*
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
        }*/

        
        for route in commonRoutes
        {
            
        }
        
        return commonRoutes.count > 0 
    }*/
    
    private static func getPredictions(stop: Stops, stopIndex: Int)->[StopsInfo]!
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

                result = StopsInfo.downloadBongoStopsInfo(jsonDictionary: todo!, optionalInfo: stopIndex)
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
