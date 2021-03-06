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
    
    var user: User!
        
    override init() {
        super.init()
    }
    
    func taskForGetMethodParse(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject],
                          completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
       
        let request = getRequestForParse(urlComponents, queryParams, method)
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethodParse", code: 1, userInfo: userInfo))
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
            
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForDataConversion: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethodParse(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], _ jsonBody: String, completionHandlerForPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForParse(urlComponents, queryParams, method)
        request.httpMethod = "POST"
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethodParse", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForDataConversion: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    
    private func getRequestForParse(_ urlComponents: [String: AnyObject], _ queryParams: [String: AnyObject], _ method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: self.urlFromParameters(urlComponents, queryParams, withPathExtension: method))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(OnTheMapClient.ParseContants.ApiKey, forHTTPHeaderField: OnTheMapClient.ParseContants.ApiKeyHeaderField)
        request.addValue(OnTheMapClient.ParseContants.AppID, forHTTPHeaderField: OnTheMapClient.ParseContants.AppIDHeaderField)
        return request
    }

    
    func taskForGetMethod(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject],
                               completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        request.httpMethod = "GET"
      
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            let newData = self.getUdacityData(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }

    
    func taskForPOSTMethod(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], jsonBody: String, completionHandlerForPOST:
        @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        
        request.httpMethod = "POST"
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, _ statusCode: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: statusCode, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("Error during request: \(error!)", 1)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 &&
                statusCode <= 299 else {
                    sendError("Request returned response other than 2xx", ((response as? HTTPURLResponse)?.statusCode)!)
                    return
            }
            
            guard data != nil else {
                sendError("No data returned from request", 1)
                return
            }
            
            let newData = self.getUdacityData(data)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    
    func taskForDELETEMethod(_ method: String, urlComponents: [String: AnyObject], queryParams: [String: AnyObject], headerParameters: [String: AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = getRequestForUdacity(urlComponents, queryParams, method)
        request.httpMethod = "DELETE"

        for (k, v) in headerParameters {
            request.setValue(k as String, forHTTPHeaderField: v as! String)
        }
        
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
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
            
            let newData = self.getUdacityData(data)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForDataConversion: completionHandlerForDELETE)
        }
        
        task.resume()
        
        return task
        
    }
    
    
    private func getRequestForUdacity(_ urlComponents: [String: AnyObject], _ queryParams: [String: AnyObject], _ method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: self.urlFromParameters(urlComponents, queryParams, withPathExtension: method))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

   
    
    private func getUdacityData(_ data: Data?) -> Data {
        
        // Remove the first 5 characters of response from Udacity
        let range = Range(5..<data!.count)
        
        let newData = data?.subdata(in: range)

        return newData!
    }
    
    private func urlFromParameters(_ urlComponents: [String: AnyObject], _ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        
        components.scheme = urlComponents[OnTheMapClient.Constants.SchemeKey] as? String
        components.host = urlComponents[OnTheMapClient.Constants.HostKey] as? String
        components.path = urlComponents[OnTheMapClient.Constants.ApiPathKey] as! String + (withPathExtension ?? "")
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
