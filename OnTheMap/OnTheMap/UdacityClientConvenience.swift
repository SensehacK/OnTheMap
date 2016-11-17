//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation


class UdacityClientConvenience {
    
    
    //session initialised
    //var session = URLSession.shared
    
    
    //Mark : Get User Session Key
    
    func getUserSessionKey(username : String,password : String, completionHandlerForUserSessionKey: @escaping (_ userkey : String? , _ error  : String? ) -> Void ) {
        
    
        //Configure the Udacity API session key
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        
        //make task network request
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data ,response , error in
            
            // guard statements incoming
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerForUserSessionKey(nil, "Error found on 1st Guard UserSessionKey")
                return
            }
            
            
            // Status code msgs
            guard let statusCodes = (response as? HTTPURLResponse)?.statusCode , statusCodes >= 200 && statusCodes <= 299 else {
                completionHandlerForUserSessionKey(nil, "Wrong Status Codes Returned")
                return
            }
            
            //Data is empty or not
            guard let data = data else {
                completionHandlerForUserSessionKey(nil, "Error found on 3rd Guard Data Empty UserSessionKey")
                return
            }
            
            
            // Parsing data 
            
            let parsedData : AnyObject
            
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            } catch {
                print("Error Catched in Parsing Data")
                completionHandlerForUserSessionKey(nil, "Error Parsing Data")
                return
            }
        
             let account = parsedData["account"] as! [String:Any]
             let userSession2 = account["key"] as! String
            
            if let userSessionKey = (parsedData["account"] as? [String: Any])? ["key"] as? String {
            UserInfo.userKey = userSessionKey
            //Printing User Session Keys
                print(userSession2)
                print(userSessionKey)
                
            completionHandlerForUserSessionKey(userSessionKey, nil)
            
        } else {
            completionHandlerForUserSessionKey(nil, "Couldnt find Session Key")
        }
            
        }
        task.resume()
        
    }
    
    
    func identifyUserWithSessionKey(userSessionKey : String , completionHandlerforIdentifyUserWithSessionKey : @escaping ( _ success : Bool? , _ error : String?) -> Void  ) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userSessionKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerforIdentifyUserWithSessionKey(false, "Error found on 1st Guard UserSessionKey")
                return
            }
            
            
            
            //Data is empty or not
            guard let data = data else {
                completionHandlerforIdentifyUserWithSessionKey(false, "Error found on 3rd Guard Data Empty UserSessionKey")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)

            
            // Parse Data & store it in User Info.swift
            
            let parsedData : AnyObject

            do {
                parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
            } catch {
                print("Error Catched in Parsing Data")
                completionHandlerforIdentifyUserWithSessionKey(false, "Error Parsing Data")
                return
            }
            
            //Retrieve User name Data
            let userData = parsedData["user"] as! NSDictionary
            let firstName = userData["first_name"] as! String
            let lastName = userData["last_name"] as! String
            
            //Store User name Data in UserInfo File
            UserInfo.firstName = firstName
            UserInfo.lastName  = lastName
            
            //Completion Handling Return closures
            completionHandlerforIdentifyUserWithSessionKey(true,nil)
       
        }
        task.resume()
    }
    
    // MARK : Deleting Session 
    
    func deleteUserSession ( completionHandlerDeleteUserSession : @escaping ( _ success : Bool , _ error : String?) -> Void ) {
        
        
        //Copied from Udacity Example code
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            // first guard for error is empty
            guard error == nil else {
                print(error)
                completionHandlerDeleteUserSession(false, "We couldn't Log you out")
                return
            }
            
            // If no errors were found & Exit the function with Completion Handler 
            completionHandlerDeleteUserSession(true, nil)
            
            /* Why check Range Now ? In the Default Code & Printing the raw value.
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            */
            
        }
        task.resume()
    }
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClientConvenience {
        struct Singleton {
            static var sharedInstance = UdacityClientConvenience()
        }
        return Singleton.sharedInstance
    }

    
    
    
}
