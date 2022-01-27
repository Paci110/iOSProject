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
    public final let nameForEKCalendar: String = "iOSProject"
    let store: EKEventStore
    
    init() {
        store = EKEventStore()
    }
    
    public func saveEventsToEK() {
        let calendars = getCalendars(filterFor: nil)
        Task.init {
            guard await askForPermission(store: store) else {return}
            
            let ekCalendar = await getEKCalendar()
            removeEventsFromEK(cal: ekCalendar)
            
            for calendar in calendars {
                guard calendar.title != iOSCalendarName else {continue}
                
                for event in calendar.dateEvents! {
                    let dateEvent = event as! DateEvent
                    let ekEvent = EKEvent(eventStore: store)
                    ekEvent.title = dateEvent.title
                    ekEvent.startDate = dateEvent.start
                    ekEvent.endDate = dateEvent.end
                    ekEvent.isAllDay = dateEvent.fullDayEvent
                    ekEvent.notes = dateEvent.notes
                    ekEvent.url = dateEvent.url
                    ekEvent.calendar = ekCalendar
                    do {
                        print("Saving to iCal")
                        try store.save(ekEvent, span: .thisEvent)
                    } catch {
                        print(error)
                    }
                }
            }
            do {
                try store.commit()
            }catch {
                print(error)
            }
        }
    }
    
    public func loadEKEvents(completionHandler: (([DateEvent]) -> Void)?) {
        let calendars = getCalendars(filterFor: [iOSCalendarName])
        let calendar = calendars.isEmpty ? Calendar(title: iOSCalendarName, color: UIColor.gray) : calendars[0]
        
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
            saveData()
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
    
    private func removeEventsFromEK(cal: EKCalendar) {
        let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
        let inThreeYears = Foundation.Calendar.current.date(byAdding: .year, value: 3, to: oneMonthAgo) ?? Date(timeIntervalSinceNow: 60*60*24*30)
        let predicate = store.predicateForEvents(withStart: oneMonthAgo, end: inThreeYears, calendars: [cal])
        let events = store.events(matching: predicate)
        do {
            for event in events {
                try store.remove(event, span: .thisEvent)
            }
            try store.commit()
        }catch {
            print(error)
        }
    }
    
    private func getEKCalendar() async -> EKCalendar {
        let calendars = store.calendars(for: .event).filter {
            cal in
            cal.title == nameForEKCalendar
        }
        if(calendars.count > 0) {
            return calendars[0]
        }
        print("Creating new Calendar for the iOS app")
        let calendar = EKCalendar(for: .event, eventStore: store)
        calendar.title = nameForEKCalendar
        calendar.cgColor = CGColor(red: 255, green: 0, blue: 255, alpha: 1)
        calendar.source = store.sources[0]
        print(store.sources)
        
        do {
            try store.saveCalendar(calendar, commit: true)
        } catch {
            print(error)
        }
        
        return calendar
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
