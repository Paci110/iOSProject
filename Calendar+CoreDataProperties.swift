//
//  Calendar+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 06.01.22.
//
//

import Foundation
import CoreData
import UIKit

extension Calendar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calendar> {
        return NSFetchRequest<Calendar>(entityName: "Calendar")
    }

    @NSManaged public var color: UIColor
    @NSManaged public var dateEvents: NSSet?

}

// MARK: Generated accessors for dateEvents
extension Calendar {

    @objc(addDateEventsObject:)
    @NSManaged public func addToDateEvents(_ value: DateEventCoreData)

    @objc(removeDateEventsObject:)
    @NSManaged public func removeFromDateEvents(_ value: DateEventCoreData)

    @objc(addDateEvents:)
    @NSManaged public func addToDateEvents(_ values: NSSet)

    @objc(removeDateEvents:)
    @NSManaged public func removeFromDateEvents(_ values: NSSet)

}

extension Calendar : Identifiable {

}
