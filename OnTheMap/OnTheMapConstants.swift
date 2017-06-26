//
//  OnTheMapConstant.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/24/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

extension OnTheMapClient {
    struct Constants {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
    }
    
    struct SessionParameterKeys {
        static let DictionaryKey = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct JSONBodyKeys {
        static let dictionaryKey = "udacity"
        static let userNameKey = "username"
        static let passwordKey = "password"
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let userId = "key"
    }
}
