//
//  ParsingClient.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation


class ParsingClient {
    
    // Mark : Shared Instance of Parsing Client
    
    class func sharedInstance() -> ParsingClient {
        struct Singleton {
            static var sharedInstance = ParsingClient()
        }
        return Singleton.sharedInstance
    }

    
    
    
    //MARK : Helper Convenience Functions
    
    //MARK : Get Multiple Users Location
    //Get Multiple Students Location
    
    func getStudentsLocation (completionHandlerforGetStudentsLocation : @escaping (_ success : Bool? , _ error : String?) -> Void) {
        
        //Create & edit a request
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        // Pass both Application & Rest API Keys
        request.addValue(StudentInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentInfo.restKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //Session header
        let session = URLSession.shared
        
        //Make a request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // guard statements incoming
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerforGetStudentsLocation(false, "Error found on 1st Guard UserSessionKey")
                return
            }
            
            // Status code msgs
            guard let statusCodes = (response as? HTTPURLResponse)?.statusCode , statusCodes >= 200 && statusCodes <= 299 else {
                completionHandlerforGetStudentsLocation(false, "Wrong Status Codes Returned")
                return
            }
            
            //Data is empty or not
            guard let data = data else {
                completionHandlerforGetStudentsLocation(false, "Error found on 3rd Guard Data Empty UserSessionKey")
                return
            }

           /*Print Raw value on Console
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
             */
            
            let parsedResult : [String : AnyObject]
            // Optional & Downcasting for Parsed Result Ambiguity , Cant figure it out.
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                
              // Search the parsed Result & store it in Student Struct Dictionary
                StudentStructDict.sharedInstance.studentsDict = StudentInfo.studentOfResult(results: parsedResult["results"] as! [[String : AnyObject]])
                
            } catch {
                print("Error in getting User Locations Results Dictionary from Parsed result ")
                print(error)
                completionHandlerforGetStudentsLocation(false, nil)
                return
            }
            //Completion Handler Finished
            completionHandlerforGetStudentsLocation(true, nil)
            
        }
        task.resume()
    }
    
    
    
    //MARK : Get User's Location
    //User Location
    func getUserLocation (userIDUniqueKey : String , completionHandlerForGetUserLocation : @escaping (_ success : Bool? , _ error : String?)  -> Void) {
        
        
        //Create & edit a request
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(userIDUniqueKey)%22%7D")!)
        // Pass both Application & Rest API Keys
        request.addValue(StudentInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentInfo.restKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //Session header
        let session = URLSession.shared
        
        //Make a request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // guard statements incoming
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerForGetUserLocation(false, "Error found on 1st Guard UserSessionKey (func getUserLocation)")
                return
            }
            
            
            // Status code msgs
            guard let statusCodes = (response as? HTTPURLResponse)?.statusCode , statusCodes >= 200 && statusCodes <= 299 else {
                completionHandlerForGetUserLocation(false, "Wrong Status Codes Returned (func getUserLocation)")
                return
            }
            
            //Data is empty or not
            guard let data = data else {
                completionHandlerForGetUserLocation(false, "Error found on 3rd Guard Data Empty UserSessionKey (func getUserLocation)")
                return
            }
            
            
            let parsedResult : [String: AnyObject]?
            // Optional & Downcasting for Parsed Result Ambiguity , Cant figure it out.
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
                
                // Search the parsed Result & store it in Student Info Variables for easy access.
                
                // Guard Statement for userlocationAttribute dictionary search
                guard  let userLocationAttributes  = parsedResult?["results"] as? [[String : AnyObject]]
                    else {
                    print(error)
                    completionHandlerForGetUserLocation(false, "Get USerLocationAtrributes returned an error in Results data form of JSON body (data) (func getUserLocation) ")
                    return
                }
                
                
                 //userLocationAttributes has the Json data which consists of "Results"
                // Find other attributes & store it sequentially in Student Info .swift
                
                if let usermapstring = userLocationAttributes.last?["mapString"] as? String {
                   UserInfo.MapString = usermapstring
                }
                
                if let userurlstatus = userLocationAttributes.last?["mediaURL"] as? String {
                    UserInfo.UserURLStatus = userurlstatus
                }
                
                if let objectid = userLocationAttributes.last?["objectID"] as? String {
                    UserInfo.objectID = objectid
                }
                
                if let lat = userLocationAttributes.last?["latitude"] as? Double {
                    UserInfo.MapLatitude = lat
                }
                
                if let lon = userLocationAttributes.last?["longitude"] as? Double {
                    UserInfo.MapLongitude = lon
                }
               
        // Do try CAtch block JSON Serialization if failed pass
                
            } catch {
                print(error)
                completionHandlerForGetUserLocation(false, "Error in getting User Locations Results Dictionary from Parsed result (func getUserLocation) ")
                return
            }
            
            //Completion Handler Finished
            completionHandlerForGetUserLocation(true, nil)

        }
        task.resume()
    }
    
    
    
    //MARK : Post User's Location
    // Post User's location
    
    func postUserLocation (userIDUniqueKey : String , firstName : String , lastName : String , mapString : String , mediaURL : String , latitude : Double , longitude : Double , completionHandlerForPostUserLocation : @escaping (_ success : Bool? , _ error : String?) -> Void ) {
        
        // Create the request
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        // Pass both Application & Rest API Keys
        request.addValue(StudentInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentInfo.restKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(userIDUniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        //Make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
          
            // guard statements incoming
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerForPostUserLocation(false, "Error found on 1st Guard UserSessionKey ( func postUserLocation)")
                return
            }
            
            completionHandlerForPostUserLocation(true, nil)
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
        }
        task.resume()
    }
    
    
    
    
    //MARK : Update User's Location
    // Update User's Location
    
    func updateUserLocation(userIDUniqueKey : String , objectID : String , firstName : String , lastName : String , mapString : String , mediaURL : String , latitude : Double , longitude : Double , completionHandlerForUpdateUserLocation : @escaping (_ success : Bool? , _ error : String?) -> Void ) {
        
        // Create the request
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)")!)
        request.httpMethod = "PUT"
        
        // Pass both Application & Rest API Keys
        request.addValue(StudentInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentInfo.restKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(userIDUniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        //Make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            // guard statements incoming
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerForUpdateUserLocation(false, "Error found on 1st Guard UserSessionKey (func updateUserLocation) ")
                return
            }
            
            print("Value Updated for USer UpdateUserLocation")
            
            completionHandlerForUpdateUserLocation(true, nil)
            
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
        }
        task.resume()
    }
    
    
    //MARK : Remove User's Location
    // Remove User Location 
    func removeUserLocation(objectID : String , completionHandlerForRemoveUserLocation : @escaping (_ success : Bool? , _ error : String?) -> Void ) {
        
        let request = NSMutableURLRequest(url: URL(string: " https://parse.udacity.com/parse/classes/StudentLocation/\(objectID)")!)
        
        request.httpMethod = "DELETE"
        
        request.addValue(StudentInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(StudentInfo.restKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //Make a request
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response , error in
            
            //Guard error Nil check
            guard  error == nil else {
                completionHandlerForRemoveUserLocation(false, "Error found out in Remove User Location")
                return
            }
            
            //If no error , return success in completion Handler
            completionHandlerForRemoveUserLocation(true, nil)
        }
        task.resume()
    }
    
    //Last End declaration
    
   
}

