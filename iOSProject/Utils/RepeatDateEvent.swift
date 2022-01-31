//
//  RepeatDateEvent.swift
//  iOSProject
//
//  Created by Kilian Sinke on 31.01.22.
//

import Foundation
import CoreData
///Class for temporary created dateEvents used to display repeating events
public class RepeatDateEvent: DateEvent {
    
    init(original: DateEvent, newStart: Date, newEnd: Date) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "DateEvent", in: getContext())!, insertInto: nil)
//        super.init(title: original.title, fullDayEvent: original.fullDayEvent, start: original.start, end: original.end, shouldRemind: original.shouldRemind, calendar: original.calendar, notes: original.notes, series: original.series, reminder: original.reminder, url: original.url, address: "\(original.place?.locality ?? ""), \(original.place?.name)", locationHanlder: nil, notificationHanlder: nil)
        self.title = original.title
        self.fullDayEvent = original.fullDayEvent
        start = newStart
        end = newEnd
        shouldRemind = original.shouldRemind
        calendar = RepeatedCalendar(original: original.calendar)
        notes = original.notes
        //series = original.series
        reminder = original.reminder
        url = original.url
        place = original.place
    }
    
}

///Copy of a calendar
public class RepeatedCalendar: Calendar {
    init(original: Calendar) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Calendar", in: getContext())!, insertInto: nil)
        
        title = original.title
        color = original.color
    }
}
