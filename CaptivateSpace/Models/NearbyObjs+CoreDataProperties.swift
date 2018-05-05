//
//  NearbyObjs+CoreDataProperties.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 5/2/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//
//

import Foundation
import CoreData


extension NearbyObjs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NearbyObjs> {
        return NSFetchRequest<NearbyObjs>(entityName: "NearbyObjs")
    }

    @NSManaged public var des: String?
    @NSManaged public var fullname: String?
    @NSManaged public var cd: NSDate?
    @NSManaged public var dist: Float

}
