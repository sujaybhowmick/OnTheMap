//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/27/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation

struct StudentLocation {
    let objectId: String
    
    let uniqueKey: String
    
    let firstName: String
    
    let lastName: String
    
    let mapString: String
    
    let mediaURL: String
    
    let latitude: Double
    
    let longitude: Double
    
    let createdAt: String
    
    let updatedAt: String
    
}

extension StudentLocation {
    init?(result: [String: AnyObject]) {
        guard let firstName = result[OnTheMapClient.JSONResponseKeys.firstName] as? String,
            let lastName = result[OnTheMapClient.JSONResponseKeys.lastName] as? String,
            let mapString = result[OnTheMapClient.JSONResponseKeys.mapString] as? String,
            let mediaURL = result[OnTheMapClient.JSONResponseKeys.mediaURL] as? String,
            let latitude = result[OnTheMapClient.JSONResponseKeys.latitude] as? Double,
            let longitude = result[OnTheMapClient.JSONResponseKeys.longitude] as? Double,
            let createdAt = result[OnTheMapClient.JSONResponseKeys.createdAt] as? String,
            let updatedAt = result[OnTheMapClient.JSONResponseKeys.updatedAt] as? String,
            let objectId = result[OnTheMapClient.JSONResponseKeys.objectId] as? String,
            let uniqueKey = result[OnTheMapClient.JSONResponseKeys.uniqueKey] as? String
        else {
            return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.objectId = objectId
        self.uniqueKey = uniqueKey
    }
    
    static func getStudentLocations(json: [String: AnyObject]) -> [StudentLocation] {
        var studentLocations: [StudentLocation] = []
        for case let result in json[OnTheMapClient.JSONResponseKeys.results] as! [AnyObject]{
            if let studentLocation = StudentLocation(result: result as! [String: AnyObject]) {
                studentLocations.append(studentLocation)
            }
        }
        return studentLocations
    }
}