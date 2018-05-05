//
//  NearbyObjectArray.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/29/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import UIKit

final class NearbyObjectArray: NSObject {
    static var sharedInstance = [NearbyObject]()
    let nearbyObjectArray: [NearbyObject]
    private init(nearbyObjectArray: [NearbyObject]) {self.nearbyObjectArray = nearbyObjectArray}
}
