//
//  EKUtils.swift
//  iOSProject
//
//  Created by Kilian Sinke on 27.01.22.
//

import Foundation
import EventKit
import UIKit
import CoreData

public class EKUtils {
    public final let iOSCalendarName: String = "iCal"
    let store: EKEventStore
    
    init() {
        store = EKEventStore()
    }
    public func loadEKEvents(completionHandler: (([DateEvent]) -> Void)?) {
        //let calendars = getCalendars(filterFor: [iOSCalendarName])
        //let calendar = calendars.isEmpty ? Calendar(title: iOSCalendarName, color: UIColor.gray) : calendars[0]
        // Test purpose:
        let calendar = Calendar(title: iOSCalendarName, color: UIColor.gray)
        
        //"Synchronize by reseting all events in the calendar
        for event in calendar.dateEvents! {
            deleteData(dataToDelete: event as! NSManagedObject)
        }
        
        Task.init {
            for ekEvent in await fetchEKEvents() {
                if let address = ekEvent.location
                {
                    _ = DateEvent(title: ekEvent.title, fullDayEvent: ekEvent.isAllDay, start: ekEvent.startDate, end: ekEvent.endDate, shouldRemind: ekEvent.hasAlarms, calendar: calendar, notes: ekEvent.notes, series: nil, reminder: nil, url: ekEvent.url, address: address, locationHanlder: nil, notificationHanlder: nil)
                }
                else {
                    _ = DateEvent(title: ekEvent.title, fullDayEvent: ekEvent.isAllDay, start: ekEvent.startDate, end: ekEvent.endDate, shouldRemind: ekEvent.hasAlarms, calendar: calendar, notes: ekEvent.notes, series: nil, reminder: nil, url: ekEvent.url, location: nil, locationHanlder: nil, notificationHanlder: nil)
                }
                
                
            }
        }
    }

    public func fetchEKEvents() async -> [EKEvent] {
        guard await askForPermission(store: store) else {return []}
        
        let calendars = store.calendars(for: .event)
        let today = Date()
        let inFourYears = Foundation.Calendar.current.date(byAdding: .year, value: 4, to: today) ?? Date(timeIntervalSinceNow: 60*60*24*30)
        let predicate = store.predicateForEvents(withStart: today, end: inFourYears, calendars: calendars)
        
        return store.events(matching: predicate)
    }



    public func askForPermission(store: EKEventStore) async -> Bool {
        do {
            return try await store.requestAccess(to: .event)
        } catch {
            print(error)
        }
        return false
    }

}
