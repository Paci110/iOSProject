//
//  API.swift
//  iOSProject
//
//  Created by Bennet Weingartz on 17.01.22.
//

import Foundation
import CoreData

func getEvents(start: Date, end: Date, filterFor: [String]? = nil) -> [DateEvent] { //TODO: should probably be filterFor: [Calendar] with an unwrapper later
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
    
    return events
}
