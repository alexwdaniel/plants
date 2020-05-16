//
//  Plant+CoreDataProperties.swift
//  Plants
//
//  Created by Alexander Daniel on 5/16/20.
//  Copyright © 2020 adaniel. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var photo: String?
    @NSManaged public var waterFrequency: Int16
    @NSManaged public var waterings: NSOrderedSet?

}

// MARK: Generated accessors for waterings
extension Plant {

    @objc(insertObject:inWateringsAtIndex:)
    @NSManaged public func insertIntoWaterings(_ value: Watering, at idx: Int)

    @objc(removeObjectFromWateringsAtIndex:)
    @NSManaged public func removeFromWaterings(at idx: Int)

    @objc(insertWaterings:atIndexes:)
    @NSManaged public func insertIntoWaterings(_ values: [Watering], at indexes: NSIndexSet)

    @objc(removeWateringsAtIndexes:)
    @NSManaged public func removeFromWaterings(at indexes: NSIndexSet)

    @objc(replaceObjectInWateringsAtIndex:withObject:)
    @NSManaged public func replaceWaterings(at idx: Int, with value: Watering)

    @objc(replaceWateringsAtIndexes:withWaterings:)
    @NSManaged public func replaceWaterings(at indexes: NSIndexSet, with values: [Watering])

    @objc(addWateringsObject:)
    @NSManaged public func addToWaterings(_ value: Watering)

    @objc(removeWateringsObject:)
    @NSManaged public func removeFromWaterings(_ value: Watering)

    @objc(addWaterings:)
    @NSManaged public func addToWaterings(_ values: NSOrderedSet)

    @objc(removeWaterings:)
    @NSManaged public func removeFromWaterings(_ values: NSOrderedSet)

}
