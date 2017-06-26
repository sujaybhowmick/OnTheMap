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
                completionHandlerForAuth(success, errorString)
            }else {
                completionHandlerForAuth(success, errorString)
            }
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
}
