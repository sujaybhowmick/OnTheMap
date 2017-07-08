//
//  OnTheMap.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/25/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation

struct OnTheMap {
    let account: [String: AnyObject]
    
    
    init(_ dictionary: [String: AnyObject]) {
        account = dictionary[OnTheMapClient.JSONResponseKeys.account] as! [String : AnyObject]
    }
    
    func getUserId() -> String {
        return (account[OnTheMapClient.JSONResponseKeys.userId] as? String)!
    }
    
}
