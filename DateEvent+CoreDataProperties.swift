//
//  DateEvent+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 14.01.22.
//
//

import Foundation
import CoreData
import MapKit

extension DateEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateEvent> {
        return NSFetchRequest<DateEvent>(entityName: "DateEvent")
    }

    //TODO: why default initialization uses optionals
    @NSManaged public var end: Date
    @NSManaged public var fullDayEvent: Bool
    @NSManaged public var place: CLPlacemark?
    @NSManaged public var notes: String?
    @NSManaged public var shouldRemind: Bool
    @NSManaged public var start: Date
    @NSManaged public var title: String
    @NSManaged public var url: URL?
    @NSManaged public var calendar: Calendar

}

extension DateEvent : Identifiable {

}
