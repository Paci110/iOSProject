//
//  DateEventCoreData+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 06.01.22.
//
//

import Foundation
import CoreData
import MapKit

extension DateEventCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateEventCoreData> {
        return NSFetchRequest<DateEventCoreData>(entityName: "DateEventCoreData")
    }

    @NSManaged public var location: CLLocation?
    @NSManaged public var notes: String?
    @NSManaged public var title: String?
    @NSManaged public var fullDayEvent: Bool
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var shouldRemind: Bool
    @NSManaged public var url: URL?
    @NSManaged public var calendar: Calendar

}

extension DateEventCoreData : Identifiable {

}
