//
//  EventSeries+CoreDataProperties.swift
//  iOSProject
//
//  Created by Pascal Köhler on 17.01.22.
//
//

import Foundation
import CoreData

public enum TimeInterval: Int16 {
    case Hour, Day, Week, Month, Year
    
    var description: String {
        switch self {
        case .Hour: return "Hour"
        case .Day: return "Day"
        case .Week: return "Week"
        case .Month: return "Month"
        case .Year: return "Year"
        }
    }
}

extension EventSeries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventSeries> {
        return NSFetchRequest<EventSeries>(entityName: "EventSeries")
    }
    
    @NSManaged public var timeIntervalInt: Int16
    @NSManaged public var value: Int64
    
    var timeInterval: TimeInterval {
        get {
            return TimeInterval.init(rawValue: self.timeIntervalInt)!
        }
        set {
            self.timeIntervalInt = newValue.rawValue
        }
    }
}

extension EventSeries : Identifiable {

}
