//
//  OnTheMapExtension.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/26/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation
import UIKit

extension OnTheMapClient {
    func authenticateWithViewController(_ hostViewController: UIViewController, _ userName: String, _ password: String, completionHandlerForAuth: @escaping (_ sucess: Bool, _ errorString: String?) -> Void) {
        getSession(userName, password) { (success, onTheMap, errorString) in
            if success {
                if let onTheMap = onTheMap {
                    print(onTheMap.getUserId())
                    self.onTheMap = onTheMap
                }
                self.getLoggedInUserDetails() { (success, results, errorString) in
                    if success {
                        if let results = results {
                            let user = results["\(JSONResponseKeys.user)"] as! [String: AnyObject]
                            self.user = User(user)
                        }
                       
                    }
                }
            }
            completionHandlerForAuth(success, errorString)
        }
    }
    
    func logoutWithViewController(_ hostViewController: UIViewController, completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        deleteSession() { (success, errorString) in
            if success {
                print(success)
                self.onTheMap = nil
            }
            completionHandlerForLogout(success, errorString)
        }
    }
    
    func getStudentLocations(_ hostViewController: UIViewController, completionHandlerForGetStudentLocations: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        getStudentLocations() { (success, results, errorString) in
            if success {
                self.studentLocations = StudentLocation.getStudentLocations(json: results as! [String : AnyObject])
                self.count = self.studentLocations.count
            }else {
                print("Failed to fetch StudentLocations")
            }
            completionHandlerForGetStudentLocations(success, errorString)
        }
        
    }
    
    func postStudentLocation(_ studentLocation: StudentLocation, completionHanderForPOSTStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        self.postStudentLocation(studentLocation) { (success, results, errorString) in
            if success {
                print("Successfully posted student location")
            }else {
                print("post failed")
            }
            completionHanderForPOSTStudentLocation(success, errorString)
            
        }
    }
       
    private func getSession(_ userName: String, _ password: String, completionHandlerForGetSession: @escaping (_ success: Bool, _ ontheMap: OnTheMap?, _ errorString: String?) -> Void) {
        var urlComponents = [String: AnyObject]()
        urlComponents["\(OnTheMapClient.Constants.SchemeKey)"] = OnTheMapClient.AuthConstants.Scheme as AnyObject
        urlComponents["\(OnTheMapClient.Constants.HostKey)"] = OnTheMapClient.AuthConstants.Host as AnyObject
        urlComponents["\(OnTheMapClient.Constants.ApiPathKey)"] = OnTheMapClient.AuthConstants.ApiPath as AnyObject
        
        let jsonRequestBody = "{\"\(OnTheMapClient.JSONBodyKeys.dictionaryKey)\": {\"\(OnTheMapClient.JSONBodyKeys.userNameKey)\": \"\(userName)\", \"\(OnTheMapClient.JSONBodyKeys.passwordKey)\": \"\(password)\"}}"
        
        let _ = OnTheMapClient.sharedInstance().taskForPOSTMethod(OnTheMapClient.AuthMethods.Session, urlComponents: urlComponents, queryParams: [String: AnyObject](), jsonBody: jsonRequestBody) { (results, errors) in
            if let errors = errors {
                print(errors)
                completionHandlerForGetSession(false, nil, "Login failed for User: \(userName).")
            }else {
                let ontheMap = OnTheMap(results as! [String : AnyObject])
                completionHandlerForGetSession(true, ontheMap, nil)
            }
        }
    }
    
    private func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        var headerParameters = [String: AnyObject]()
        if let xsrfCookie = xsrfCookie {
            headerParameters[xsrfCookie.value] = "X-XSRF-TOKEN" as AnyObject
        }
        
        var urlComponents = [String: AnyObject]()
        urlComponents["\(OnTheMapClient.Constants.SchemeKey)"] = OnTheMapClient.AuthConstants.Scheme as AnyObject
        urlComponents["\(OnTheMapClient.Constants.HostKey)"] = OnTheMapClient.AuthConstants.Host as AnyObject
        urlComponents["\(OnTheMapClient.Constants.ApiPathKey)"] = OnTheMapClient.AuthConstants.ApiPath as AnyObject

        let _ = OnTheMapClient.sharedInstance().taskForDELETEMethod(OnTheMapClient.AuthMethods.Session, urlComponents: urlComponents, queryParams: [String: AnyObject](), headerParameters: headerParameters) { (results, errors) in
            if let errors = errors {
                print(errors)
                completionHandlerForDeleteSession(false, "Logout failed")
            }else {
                completionHandlerForDeleteSession(true, nil)
            }
            
        }
    }
    
    private func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void) {
        
        var urlComponents = [String: AnyObject]()
        
        urlComponents["\(OnTheMapClient.Constants.SchemeKey)"] = OnTheMapClient.ParseContants.Scheme as AnyObject
        urlComponents["\(OnTheMapClient.Constants.HostKey)"] = OnTheMapClient.ParseContants.Host as AnyObject
        urlComponents["\(OnTheMapClient.Constants.ApiPathKey)"] = OnTheMapClient.ParseContants.ApiPath as AnyObject
        
        
        let _ = OnTheMapClient.sharedInstance().taskForGetMethodParse(OnTheMapClient.ParseMethods.StudentLocation, urlComponents: urlComponents, queryParams: [String: AnyObject]()) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocations(false, nil, "Failed to Get Student Locations")
            }else {
                completionHandlerForGetStudentLocations(true, results, nil)
            }

        }
    }
    
    private func getLoggedInUserDetails(completionHandlerForGetLoggedInUserDetails: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void) {
        var urlComponents = [String: AnyObject]()
        urlComponents[OnTheMapClient.Constants.SchemeKey] = OnTheMapClient.AuthConstants.Scheme as AnyObject
        urlComponents[OnTheMapClient.Constants.HostKey] = OnTheMapClient.AuthConstants.Host as AnyObject
        urlComponents[OnTheMapClient.Constants.ApiPathKey] = OnTheMapClient.AuthConstants.ApiPath as AnyObject
        
        let uniqueKey = OnTheMapClient.sharedInstance().onTheMap.getUserId()
        
        let method = "\(OnTheMapClient.UserContants.Users)/\(uniqueKey)"
        
        let _ = OnTheMapClient.sharedInstance().taskForGetMethod(method, urlComponents: urlComponents, queryParams: [String: AnyObject]()) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForGetLoggedInUserDetails(false, nil, "Failed to Get LoggedIn User Information")
            }else {
                completionHandlerForGetLoggedInUserDetails(true, results, nil)
            }
            
        }
    }
    
    private func postStudentLocation(_ studentLocation: StudentLocation, completionHandlerForPOSTStudentLocation: @escaping (_ success: Bool, _ results: AnyObject?, _ errorString: String?) -> Void ){
        var urlComponents = [String: AnyObject]()
        urlComponents[OnTheMapClient.Constants.SchemeKey] = OnTheMapClient.ParseContants.Scheme as AnyObject
        urlComponents[OnTheMapClient.Constants.HostKey] = OnTheMapClient.ParseContants.Host as AnyObject
        urlComponents[OnTheMapClient.Constants.ApiPathKey] = OnTheMapClient.ParseContants.ApiPath as AnyObject

        let jsonRequestBody = "{\"\(OnTheMapClient.JSONBodyKeys.uniqueKey)\": \"\(studentLocation.uniqueKey)\", \"\(OnTheMapClient.JSONBodyKeys.firstName)\": \"\(studentLocation.firstName)\", \"\(OnTheMapClient.JSONBodyKeys.lastName)\": \"\(studentLocation.lastName)\", \"\(OnTheMapClient.JSONBodyKeys.mapString)\": \"\(studentLocation.mapString)\", \"\(OnTheMapClient.JSONBodyKeys.mediaURL)\": \"\(studentLocation.mediaURL)\", \"\(OnTheMapClient.JSONBodyKeys.latitude)\": \(studentLocation.latitude), \"\(OnTheMapClient.JSONBodyKeys.longitude)\": \(studentLocation.longitude)}"
        
        print(jsonRequestBody)
        
        let _ = OnTheMapClient.sharedInstance().taskForPOSTMethodParse(OnTheMapClient.ParseMethods.StudentLocation, urlComponents: urlComponents, queryParams: [String: AnyObject](), jsonRequestBody) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForPOSTStudentLocation(false, nil, "Failed to Post Student Location")
            }else {
                completionHandlerForPOSTStudentLocation(true, results, nil)
            }
            
        }
    }
}
