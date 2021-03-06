//
//  API.swift
//  iOSProject
//
//  Created by Bennet Weingartz on 17.01.22.
//

import Foundation
import CoreData
import CoreVideo


/**
 Fetches events in a timespan. May filter for an array of calendars
 - Parameter start: start of timespan
 - Parameter end: end of timespan
 - Parameter filterFor?: calendars to filter for
 - Returns: array of DateEvents in the selected timespan
 */
func getEvents(start: Date, end: Date, filterFor: [String]? = nil) -> [DateEvent] {
    let context = getContext()
    let calendars = getCalendars(filterFor: filterFor)
    
    let eventsFetch = NSFetchRequest<DateEvent>(entityName: "DateEvent")
    if(filterFor != nil) {
        eventsFetch.predicate = NSPredicate(format: "(start >= %@ AND start <= %@) OR (end >= %@ AND end <= %@) OR (start <= %@ AND end >= %@) AND calendar IN %@", argumentArray: [start, end, start, end, start, end, calendars])
    } else {
        eventsFetch.predicate = NSPredicate(format: "(start >= %@ AND start <= %@) OR (end >= %@ AND end <= %@) OR (start <= %@ AND end >= %@)", argumentArray: [start, end, start, end, start, end])
            
    }
    
    var events: [DateEvent]
    do {
        events = try context.fetch(eventsFetch)
    } catch {
        fatalError("Events couldn't be fetched: \(error)")
    }
    
    events.sort {
        $0.start <= $1.start
    }
    
    return events
}

/**
 Fetches events in a day. May filter for an array of calendars
 - Parameter day: day of the selected date
 - Parameter month: month of the selected date
 - Parameter year: year of the selected date
 - Parameter filterFor?: calendars to filter for
 - Returns: array of DateEvents in the selected day
 */
public func getDay(day: Int, month: Int, year: Int, filterFor: [String]? = nil) -> [DateEvent] {
    let start = getDate(fromString: "\(day)/\(month)/\(year) 00:00")
    let end = getDate(fromString: "\(day)/\(month)/\(year) 23:59")
    
    return getEvents(start:start, end:end, filterFor: filterFor)
}

/**
 Fetches events in a day. May filter for an array of calendars
 - Parameter date: selected date
 - Parameter filterFor?: calendars to filter for
 - Returns: array of DateEvents in the selected day
 */
public func getDay(from date: Date, filterFor: [String]? = nil) -> [DateEvent] {
    let dateString = getDate(FromDate: date, Format: "d.MM.YYYY").split(separator: ".")
    return getDay(day: Int(dateString[0])!, month: Int(dateString[1])!, year: Int(dateString[2])!, filterFor: filterFor)
}

/**
 Fetches events in a week. May filter for an array of calendars
 - Parameter date: date within the selected week
 - Parameter filterFor?: calendars to filter for
 - Returns: 2D-array of DateEvents in the selected week, array'd by day
 */
public func getWeek(date: Date, filterFor: [String]? = nil) -> [[DateEvent]] {
    var dateEvents: [[DateEvent]] = []
    var calendar = NSCalendar.current
    calendar.firstWeekday = 2
    if let interv = calendar.dateInterval(of: .weekOfYear, for: date) {
        for i in 0...6 {
            if let day = calendar.date(byAdding: .day, value: i, to: interv.start) {
                dateEvents.append(getDay(from: day, filterFor: filterFor))
            }
        }
    }
    return dateEvents
}

/**
 Fetches events in a week. May filter for an array of calendars
 - Parameter cw: selected calendar week
 - Parameter year: selected year
 - Parameter filterFor?: calendars to filter for
 - Returns: 2D-array of DateEvents in the selected week, array'd by day
 */
public func getWeek(cw: Int, year: Int, filterFor: [String]? = nil) -> [[DateEvent]] {
    var calendar = NSCalendar.current
    calendar.firstWeekday = 2
    calendar.locale = Locale(identifier: "de")
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.weekOfYear = cw
    dateComponents.weekday = 2
    let day = calendar.date(from: dateComponents)!
    print("Weekday ", day)
    return getWeek(date: day, filterFor: filterFor)
}

/*
public func getWeek(cw: Int, year: Int, filterFor: [String]? = nil) -> [[DateEvent]] {
    let firstDay = getDate(fromString: "1/1/\(year) 01:00")//
    let offset: Int = 7 - getWeekDay(date: firstDay).rawValue
    
    var start: Date
    if(cw == 1){
        start = Date(timeInterval: Double(offset - 7) * 24.0 * 60.0 * 60.0, since: firstDay)
    } else {
        start = Date(timeInterval: Double((cw - 2) * 7 + offset) * 24.0 * 60.0 * 60.0, since: firstDay)
    } //cw - 2 because of first week overlap and counting from 0
    
    var events: [[DateEvent]] = []
    for index in 0...6 {
        let date = Date(timeInterval: Double(index) * 24.0 * 60.0 * 60.0, since: start)
        let day = dateToDMY(date: date)
        let dayEvents = getDay(day: day[0], month:day[1], year:day[2], filterFor: filterFor)
        events.append(dayEvents)
    }
    
    return events
}
 */

/**
 Fetches events in a month. May filter for an array of calendars
 - Parameter month: selected month number
 - Parameter year: selected year
 - Parameter filterFor?: calendars to filter for
 - Returns: 2D-array of DateEvents in the selected month, array'd by day
 */
public func getMonth(month: Int, year: Int, filterFor: [String]? = nil) -> [[DateEvent]] {
    let firstDay = getDate(fromString: "1/\(month)/\(year) 01:00")
    
    var events: [[DateEvent]] = []
    var currentDay = firstDay
    while(Int(getDate(FromDate: currentDay, Format: "MM"))! == month){
        let day = dateToDMY(date: currentDay)
        let dayEvents = getDay(day: day[0], month:day[1], year:day[2], filterFor: filterFor)
        events.append(dayEvents)
        currentDay = Date(timeInterval: 24.0 * 60.0 * 60.0, since: currentDay)
    }
    
    return events
}

/**
 Fetches events in a year. May filter for an array of calendars
 - Parameter year: selected year
 - Parameter filterFor?: calendars to filter for
 - Returns: 3D-array of DateEvents in the selected year, array'd by month, array'd by day
 */
public func getYear(year: Int, filterFor: [String]? = nil) -> [[[DateEvent]]] {
    var events: [[[DateEvent]]] = []
    for index in 1...12 {
        let monthEvents = getMonth(month: index, year: year, filterFor: filterFor)
        
        events.append(monthEvents)
    }
    
    return events
}

/**
 Fetches calendars. May filter for an array of calendars
 - Parameter filterFor?: calendars to filter for
 - Returns: array of fetched calendars
 */
public func getCalendars(filterFor: [String]? = nil) -> [Calendar] {
    let context = getContext()
    
    let calendarsFetch = NSFetchRequest<Calendar>(entityName: "Calendar")
    if(filterFor != nil) {
        calendarsFetch.predicate = NSPredicate(format: "title IN %@", argumentArray: [filterFor!])
    }
    
    var calendars: [Calendar]
    do {
        calendars = try context.fetch(calendarsFetch)
    } catch {
        fatalError("Calendars couldn't be fetched: \(error)")
    }
    
    return calendars
}

public func getOriginalRepeatingEvents(filterFor: [String]? = nil) -> [DateEvent] {
    let context = getContext()
    let calendars = getCalendars(filterFor: filterFor)
    let eventsFetch = NSFetchRequest<DateEvent>(entityName: "DateEvent")
    if(filterFor != nil) {
        eventsFetch.predicate = NSPredicate(format: "series != nil AND calendar IN %@", argumentArray: [calendars])
    }else {
        eventsFetch.predicate = NSPredicate(format: "series != nil")
    }
    
    var events: [DateEvent] = []
    do {
        events = try context.fetch(eventsFetch)
    }catch {
        print(error)
    }
    
    return events
}

private func onSameDay(one: [Int], two: [Int]) -> Bool {
    return one[0] == two[0] && one[1] == two[1] && one[2] == two[2]
}

///Creates RepeatDateEvent Objects which fall on the given date
public func createRepeatedEvents(forDate: Date, filterFor: [String]) -> [RepeatDateEvent]{
    var clones: [RepeatDateEvent] = []
    for original in getOriginalRepeatingEvents(filterFor: filterFor){
        //Calculate if the original has a repeating falling on 'for'
        let calHelp = Foundation.Calendar.current
        var repeatedDay = original.start
        let timeDiff = original.start.distance(to: original.end)
        while(repeatedDay < forDate) {
            if(onSameDay(one: dateToDMY(date: repeatedDay), two: dateToDMY(date: forDate))) {
                clones.append(RepeatDateEvent(original: original, newStart: repeatedDay, newEnd: repeatedDay.addingTimeInterval(timeDiff)))
            }
            switch(original.series!.timeInterval) {
            case .Hour:
                repeatedDay = calHelp.date(byAdding: .hour, value: Int(original.series!.value), to: repeatedDay)!
            case .Day:
                repeatedDay = calHelp.date(byAdding: .day, value: Int(original.series!.value), to: repeatedDay)!
            case .Week:
                repeatedDay = calHelp.date(byAdding: .day, value: Int(original.series!.value) * 7, to: repeatedDay)!
            case .Month:
                repeatedDay = calHelp.date(byAdding: .month, value: Int(original.series!.value), to: repeatedDay)!
            case .Year:
                repeatedDay = calHelp.date(byAdding: .year, value: Int(original.series!.value), to: repeatedDay)!
            }
            
            
        }
    }
    return clones
}

/// Returns all calenders that should events be fetched from
public var toFetchCalendars: [String] {
    var toFetchCalendar: [String] = []
    for calendar in getCalendars() {
        if calendar.selected {
            toFetchCalendar.append(calendar.title)
        }
    }
    return toFetchCalendar
}
