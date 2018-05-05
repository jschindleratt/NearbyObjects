//
//  SIClient.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/18/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import Foundation
import UIKit

class SIClient {
    static let sharedInstance = SIClient()
    private init(){}
    
    static var intPageNumber: Int = 0
    
    func getObjects(completionHandlerForObjects: @escaping (_ studentData: [NearbyObject?]?, _ error: NSError?) -> Void) -> URLSessionTask {
        let date = Calendar.current.date(byAdding: .year, value: Int(UserDefaults.standard.double(forKey: "numberOfYears")), to: Date())
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        /* 1. Set the parameters*/
        let methodParameters = [
            SIClient.NasaParameterKeys.DateMin:dateFormatterGet.string(from: Date()),
            SIClient.NasaParameterKeys.DateMax: dateFormatterGet.string(from: date!),
            SIClient.NasaParameterKeys.DistMax: UserDefaults.standard.double(forKey: "lunarDistances"),
            SIClient.NasaParameterKeys.FullName: SIClient.NasaParameterValues.FullName,
            SIClient.NasaParameterKeys.Limit: SIClient.NasaParameterValues.Limit
            ] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        let urlString = SIClient.Nasa.APIBaseURL + escapedParameters(methodParameters as [String:AnyObject])
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs
            func sendError(_ error: String, code:Int) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForObjects(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)",code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!",code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",code: 3)
                return
            }
            
            //5. Parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'",code: 4)
                return
            }

            /* GUARD: Any matches? */
            guard let count = parsedResult[SIClient.NasaResponseKeys.Count] as? String, Int(count)! > 0 else {
                sendError("No matches",code: 5)
                return
            }
            
            /* GUARD: Is "data" key in our result? */
            guard let outerArray = parsedResult[SIClient.NasaResponseKeys.Data]! as? [[String]]
                else {
                    sendError("Cannot find key '\(SIClient.NasaResponseKeys.Data)' in \(parsedResult)",code: 6)
                    return
            }

            var arrayofDics = [[String:Any]]()
            var dicNearbyObjects = [String:Any]()
            
            for i in 0...outerArray.count - 1 {
                let innerArray = outerArray[i]
                dicNearbyObjects["designation"] = innerArray[0]
                dicNearbyObjects["approachtime"] = innerArray[3]
                dicNearbyObjects["distance"] = innerArray[4]
                dicNearbyObjects["fullName"] = innerArray[11].trimmingCharacters(in: .whitespacesAndNewlines)
                arrayofDics.append(dicNearbyObjects)
            }
            NearbyObject.objectsFromResults((arrayofDics as [[String:AnyObject]]))
            let nearbyObjects: [NearbyObject] = NearbyObjectArray.sharedInstance

            /* 6. Use the data!*/
            completionHandlerForObjects(nearbyObjects, nil)
        }
        task.resume()
        return task
    }
    
    // MARK: Helper for Escaping Parameters in URL
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                // make sure that it is a string value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
