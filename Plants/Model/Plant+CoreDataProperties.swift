//
//  Plant+CoreDataProperties.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var waterFrequency: Int16
    @NSManaged public var notes: String?
    @NSManaged public var photo: String?
    @NSManaged public var createdAt: Date?

}
