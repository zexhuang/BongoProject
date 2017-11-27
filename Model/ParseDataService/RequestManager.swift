//
//  RequestManager.swift
//  Bongo
//
//  Created by Huangzexian on 10/26/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation
class RequestManager{
    
    
    
    func makeGetCall()-> URLSessionTask{
        
        // Set up the URL request
        let todoEndpoint: String = ""
        let url = URL(string: todoEndpoint)
        let urlRequest = URLRequest(url: url!)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest){
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
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + (todo?.description)!)
                DispatchQueue.main.async {
                    
                    
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        return task
    }
    
    
}
