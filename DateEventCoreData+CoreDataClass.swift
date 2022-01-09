//
//  DateEventCoreData+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 06.01.22.
//
//

import Foundation
import CoreData
import MapKit


public class DateEventCoreData: NSManagedObject {

    //TODO: should calender be optional or not?
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind remind: Bool, calendar: Calendar, notes: String? = nil, url: URL? = nil, location: CLLocation? = nil) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        self.title = title
        self.notes = notes
        self.shouldRemind = remind
        self.url = url
        self.calendar = calendar
        self.location = location
      
        self.fullDayEvent = fullDayEvent
        self.start = start
        if start > end {
            print("End date was before start date")
            self.end = start
        }
        else {
            self.end = end
        }
        
        //If the date is an full day event the date is edited to start at 0:00 and end at 23:59 of the start, end date
        if fullDayEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let startDateString = formatter.string(from: start) + " 0:00"
            self.start = getDate(fromString: startDateString)
            let endDateString = formatter.string(from: end) + " 23:59"
            self.end = getDate(fromString: endDateString)
        }
    }
    
}
