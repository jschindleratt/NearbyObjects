//
//  NearbyObject.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/22/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

struct NearbyObject {
    var des: String! //designation
    var fullname: String!
    var dist: String
    var cd: String
    
    init(dictionary: [String:AnyObject]) {
        if let desString = dictionary[SIClient.NasaResponseKeys.Des] as? String {
            des = desString
        } else {
            des = nil
        }
        if let fullnameString = dictionary[SIClient.NasaResponseKeys.Fullname] as? String {
            fullname = fullnameString
        } else {
            fullname = nil
        }
        if let distString = dictionary[SIClient.NasaResponseKeys.Dist] as? String {
            dist = distString
        } else {
            dist = ""
        }
        if let cdString = dictionary[SIClient.NasaResponseKeys.Cd] as? String {
            cd = cdString
        } else {
            cd = ""
        }
    }
    
    static func objectsFromResults(_ results: [[String:AnyObject]]) -> [NearbyObject] {
        var objects = [NearbyObject]()
        
        // iterate through array of dictionaries, each Nearby Object is a dictionary
        for result in results {
            objects.append(NearbyObject(dictionary: result))
        }
        NearbyObjectArray.sharedInstance = objects
        return objects
    }
}
