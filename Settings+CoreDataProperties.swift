//
//  Settings+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 29.01.22.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var colorTheme: String
    @NSManaged public var defaultView: String?
    @NSManaged public var lastView: String
    @NSManaged public var startWithLastView: Bool
    @NSManaged public var showWeekNumbers: Bool

}

extension Settings : Identifiable {

}
