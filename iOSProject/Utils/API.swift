//
//  API.swift
//  iOSProject
//
//  Created by Bennet Weingartz on 17.01.22.
//

import Foundation
import CoreData


func getEvents(start: Date, end: Date, filterFor: [String]? = nil) -> [DateEvent] { //TODO: should probably be filterFor: [Calendar]? with an unwrapper later
    let context = getContext()
    
    let calendarsFetch = NSFetchRequest<Calendar>(entityName: "Calendar")
    if(filterFor != nil) {
        calendarsFetch.predicate = NSPredicate(format: "name IN %@", argumentArray: [filterFor!])
    }
    
    var calendars: [Calendar]
    do {
        calendars = try context.fetch(calendarsFetch)
    } catch {
        fatalError("Calendars couldn't be fetched: \(error)")
    }
    
    let eventsFetch = NSFetchRequest<DateEvent>(entityName: "DateEvent")
    if(filterFor != nil) {
        eventsFetch.predicate = NSPredicate(format: "start >= %@ AND end <= %@ AND calendar IN %@", argumentArray: [start, end, calendars])
    } else {
        eventsFetch.predicate = NSPredicate(format: "start >= %@ AND end <= %@", argumentArray: [start, end])
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


public func getDay(day: Int, month: Int, year: Int) -> [DateEvent] { //TODO: needs value checking
    let start = getDate(fromString: "\(day)/\(month)/\(year) 00:00")
    let end = getDate(fromString: "\(day)/\(month)/\(year) 23:59")
    
    return getEvents(start:start, end:end)
}


public func getWeek(cw: Int, year: Int) -> [[DateEvent]] { //TODO: needs value checking
    let firstDay = getDate(fromString: "1/1/\(year) 01:00")//FIXME: 00:00 returns 31st december 23:00 in locale 0000 :/
    let offset: Int = 7 - getWeekDay(date: firstDay)
    
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
        let dayEvents = getDay(day: day[0], month:day[1], year:day[2])
        events.append(dayEvents)
    }
    
    return events
}

public func getMonth(month: Int, year: Int) -> [[DateEvent]] {
    let firstDay = getDate(fromString: "1/\(month)/\(year) 01:00")//FIXME: as above
    
    var events: [[DateEvent]] = []
    var currentDay = firstDay
    while(Int(getDate(FromDate: currentDay, Format: "MM"))! == month){
        let day = dateToDMY(date: currentDay)
        let dayEvents = getDay(day: day[0], month:day[1], year:day[2])
        events.append(dayEvents)
        currentDay = Date(timeInterval: 24.0 * 60.0 * 60.0, since: currentDay)
    }
    
    return events
}

public func getYear(year: Int) -> [[[DateEvent]]] {
    let firstDay = getDate(fromString: "1/1/\(year)")
    
    var events: [[[DateEvent]]] = []
    for index in 1...12 {
        let monthEvents = getMonth(month: index, year: year)
        
        events.append(monthEvents)
    }
    
    return events
}

//TODO: Upload calendar implementation files