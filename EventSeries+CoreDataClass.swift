//
//  EventSeries+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 17.01.22.
//
//

import Foundation
import CoreData

public class EventSeries: NSManagedObject {
    
    convenience init(value: Int64, timeInterval: TimeInterval) {
        self.init(context: getContext())
        self.value = value
        self.timeInterval = timeInterval
    }
}
