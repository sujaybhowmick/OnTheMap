//
//  OnTheMapConstant.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/24/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

extension OnTheMapClient {
    struct Constants {
        static let SchemeKey = "scheme"
        static let ApiPathKey = "apiPath"
        static let HostKey = "host"
    }
    struct AuthConstants {
        
        static let Host = "www.udacity.com"
        static let Scheme = "https"
        static let ApiPath = "/api"
    }
    
    struct AuthMethods {
        static let Session = "/session"
    }
    
    struct SessionParameterKeys {
        static let DictionaryKey = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct ParseContants {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let StudentLocation = "/StudentLocation"
        
        
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let AppIDHeaderField = "X-Parse-Application-Id"
        
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiKeyHeaderField = "X-Parse-REST-API-Key"
    }
    
    struct ParseMethods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParseMethodParams {
        static let StudentLocationOrder = "order"
        static let StudentLocationLimit = "limit"
        static let StudentLocationSkip = "skip"
    }
    
    struct JSONBodyKeys {
        static let dictionaryKey = "udacity"
        static let userNameKey = "username"
        static let passwordKey = "password"
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let userId = "key"
        static let results = "results"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
}
