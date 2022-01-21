//
//  DateEvent+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 17.01.22.
//
//

import Foundation
import CoreData
import MapKit

extension DateEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateEvent> {
        return NSFetchRequest<DateEvent>(entityName: "DateEvent")
    }

    @NSManaged public var end: Date
    @NSManaged public var fullDayEvent: Bool
    @NSManaged public var notes: String?
    @NSManaged public var place: CLPlacemark?
    @NSManaged public var shouldRemind: Bool
    @NSManaged public var start: Date
    @NSManaged public var title: String
    @NSManaged public var url: URL?
    @NSManaged public var calendar: Calendar
    @NSManaged public var series: EventSeries?
    @NSManaged public var reminder: Date?

}

extension DateEvent : Identifiable {

}
