//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Sensehack on 17/11/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation

class StudentInfo {
    
    
    static let appID="QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restKey="QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    var firstName : String
    var lastName  : String
    var createdAt : String
    var updatedAt : String
    var mediaURL  : String
    var uniqueKey : String
    var objectID  : String
    var mapString : String
    var latitude  : Float
    var longitude : Float
   
    
    
    
    init?(dictionary: [String: AnyObject]) {
        
        guard let firstN = dictionary["firstName"] as? String else { return nil}
        firstName = firstN
        
        guard let lastN = dictionary["lastName"] as? String else { return nil}
        lastName = lastN
        
        
        guard let creatA = dictionary["createdAt"] as? String else { return nil}
        createdAt = creatA
        
        guard let updateA = dictionary["updatedAt"] as? String else { return nil}
        updatedAt = updateA
        
        guard let media = dictionary["mediaURL"] as? String else { return nil}
        mediaURL = media
        
        guard let unique = dictionary["uniqueKey"] as? String else { return nil}
        uniqueKey = unique
        
        guard let object = dictionary["objectId"] as? String else { return nil}
        objectID = object
        
        guard let map = dictionary["mapString"] as? String else { return nil}
        mapString = map
        
        guard let lat = dictionary["latitude"] as? Float else { return nil}
        latitude = lat
        
        guard let lon = dictionary["longitude"] as? Float else { return nil }
        longitude = lon
        
        /* ACL unknown
        guard let acl = dictionary["ACL"] as? ACL else { return nil}
        ACL = acl
        */

    }
    
    
  static func  studentOfResult(results : [[String : AnyObject]]) -> [StudentInfo] {
        var studentsResult = [StudentInfo]()
    
            for student in results {
                if let eachStudent = StudentInfo(dictionary: student) {
                    studentsResult.append(eachStudent)
                }
            }
        return studentsResult
    }
    
    
    
    
    
}
