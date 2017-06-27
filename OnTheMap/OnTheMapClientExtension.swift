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
    
    private func getSession(_ userName: String, _ password: String, completionHandlerForGetSession: @escaping (_ success: Bool, _ ontheMap: OnTheMap?, _ errorString: String?) -> Void) {
        let requestParams = [String: AnyObject]()
        let jsonRequestBody = "{\"\(OnTheMapClient.JSONBodyKeys.dictionaryKey)\": {\"\(OnTheMapClient.JSONBodyKeys.userNameKey)\": \"\(userName)\", \"\(OnTheMapClient.JSONBodyKeys.passwordKey)\": \"\(password)\"}}"
        
        print(jsonRequestBody)
        
        let _ = OnTheMapClient.sharedInstance().taskForPOSTMethod(OnTheMapClient.Methods.Session, parameters: requestParams, jsonBody: jsonRequestBody) { (results, errors) in
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
        let _ = OnTheMapClient.sharedInstance().taskForDELETEMethod(OnTheMapClient.Methods.Session, parameters: [String: AnyObject](), headerParameters: headerParameters) { (results, errors) in
            if let errors = errors {
                print(errors)
                completionHandlerForDeleteSession(false, "Logout failed")
            }else {
                completionHandlerForDeleteSession(true, nil)
            }
            
        }
        
    }
    
}
