//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/24/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation

class OnTheMapClient: NSObject {
    // Shared URLSession Object
    var urlSession = URLSession.shared
    
    var onTheMap: OnTheMap!
    
    override init() {
        super.init()
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST:
        @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityUrlFromParameters(parameters, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("Error during request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 &&
                statusCode <= 299 else {
                    sendError("Request returned response other than 2xx")
                    return
            }
            
            guard data != nil else {
                sendError("No data returned from request")
                return
            }
            // Remove the first 5 characters of response from Udacity
            let range = Range(5..<data!.count)
            
            let newData = data?.subdata(in: range)
            
            self.convertDataWithCompletionHandler(newData!, completionHandlerForDataConversion: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    private func udacityUrlFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        
        components.scheme = OnTheMapClient.Constants.Scheme
        components.host = OnTheMapClient.Constants.Host
        components.path = OnTheMapClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for(key, value)  in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForDataConversion: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForDataConversion(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForDataConversion(parsedResult, nil)
    }
    
    class func sharedInstance() -> OnTheMapClient {
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        return Singleton.sharedInstance
    }
    
}
