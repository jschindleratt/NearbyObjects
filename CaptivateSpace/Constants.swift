//
//  Constants.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/18/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

extension SIClient {
    struct Nasa {
        static let APIBaseURL = "https://ssd-api.jpl.nasa.gov/cad.api/"
    }
    
    struct NasaParameterKeys {
        static let DistMax = "dist-max"
        static let DateMin = "date-min"
        static let DateMax = "date-max"
        static let FullName = "fullname"
        static let Limit = "limit"
    }
    
    struct NasaParameterValues {
        static let FullName = "true"
        static let Limit = "100"
    }
    
    struct NasaResponseKeys {
        static let Status = "stat"
        static let Fields = "fields"
        static let Data = "data"
        static let MediumURL = "url_m"
        static let Count = "count"
        static let Des = "designation"
        static let Fullname = "fullName"
        static let Dist = "distance"
        static let Cd = "approachtime"
    }

    struct NasaResponseValues {
        static let OKStatus = "ok"
    }
}
