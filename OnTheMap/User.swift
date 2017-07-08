//
//  User.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 7/7/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation

struct User {
    let uniqueKey: String
    let firstName: String
    let lastName: String
   
}

extension User {
    
    init?(_ parameters: [String: AnyObject]) {
        guard let firstName = parameters[OnTheMapClient.JSONResponseKeys.first_name] as? String,
            let lastName = parameters[OnTheMapClient.JSONResponseKeys.last_name] as? String,
            let uniqueKey = parameters[OnTheMapClient.JSONResponseKeys.userId] as? String
        
        else {
            return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.uniqueKey = uniqueKey
    }
}
