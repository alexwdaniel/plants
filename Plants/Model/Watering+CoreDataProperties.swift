//
//  Watering+CoreDataProperties.swift
//  Plants
//
//  Created by Alexander Daniel on 5/16/20.
//  Copyright © 2020 adaniel. All rights reserved.
//
//

import Foundation
import CoreData


extension Watering {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Watering> {
        return NSFetchRequest<Watering>(entityName: "Watering")
    }

    @NSManaged public var happenedAt: Date?
    @NSManaged public var plant: Plant?

}
