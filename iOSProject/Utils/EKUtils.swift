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

public enum CompletionType {
    case deniedPermission
    case ekError
    case done
}

public class EKUtils {
    public final let iOSCalendarName: String = "iCal"
    public final let nameForEKCalendar: String = "iOSProject"
    let store: EKEventStore
    
    init() {
        store = EKEventStore()
    }
    
    public func synchronize(saveHandler: ((CompletionType) -> Void)?, loadHandler: ((CompletionType) -> Void)?) {
        saveEventsToEK {
            res in
            saveHandler?(res)
        }
        loadEKEvents {
            res in
            loadHandler?(res)
        }
    }
    
    ///Tries to save the events of this app to the iOS calendar app. Completion handler is called with false if the permission is denied.
    public func saveEventsToEK(completionHandler: @escaping (CompletionType) -> Void) {
        let calendars = getCalendars(filterFor: nil)
        askForPermission(store: store) {
            permission in
            guard permission == .done else {
                completionHandler(permission)
                return
            }
            
            let ekCalendar = self.getEKCalendar()
            self.removeEventsFromEK(cal: ekCalendar)
            
            for calendar in calendars {
                guard calendar.title != self.iOSCalendarName else {continue}
                
                for event in calendar.dateEvents! {
                    let dateEvent = event as! DateEvent
                    let ekEvent = EKEvent(eventStore: self.store)
                    ekEvent.title = dateEvent.title
                    ekEvent.startDate = dateEvent.start
                    ekEvent.endDate = dateEvent.end
                    ekEvent.isAllDay = dateEvent.fullDayEvent
                    ekEvent.notes = dateEvent.notes
                    ekEvent.url = dateEvent.url
                    ekEvent.location = "\(dateEvent.place?.locality ?? ""), \(dateEvent.place?.name ?? "")"
                    ekEvent.calendar = ekCalendar
                    do {
                        print("Saving to iCal")
                        try self.store.save(ekEvent, span: .thisEvent)
                    } catch {
                        print(error)
                        completionHandler(.ekError)
                    }
                }
            }
            do {
                try self.store.commit()
                completionHandler(.done)
            }catch {
                print(error)
                completionHandler(.ekError)
            }
        }
        
    }
    
    ///Loads the Events from the iOS Apps. Creates the DateEvents. Does not call saveData()
    public func loadEKEvents(completionHandler: @escaping (CompletionType) -> Void) {
        
        let calendars = getCalendars(filterFor: [iOSCalendarName])
        let calendar = calendars.isEmpty ? Calendar(title: iOSCalendarName, color: UIColor.gray) : calendars[0]
        
        //"Synchronize by reseting all events in the calendar
        for event in calendar.dateEvents! {
            deleteData(dataToDelete: event as! NSManagedObject)
        }
        fetchEKEvents() {
            events, permission in
            guard permission == .done else {
                completionHandler(permission)
                return
            }
            
            for ekEvent in events {
                print(ekEvent.title)
                //Skip events of our calendar from the iOS app
                if(ekEvent.calendar.title == self.nameForEKCalendar) {
                    continue
                }
                DispatchQueue.main.async {
                    
                    if let address = ekEvent.location
                    {
                        _ = DateEvent(title: ekEvent.title, fullDayEvent: ekEvent.isAllDay, start: ekEvent.startDate, end: ekEvent.endDate, shouldRemind: ekEvent.hasAlarms, calendar: calendar, notes: ekEvent.notes, series: nil, reminder: nil, url: ekEvent.url, address: address, locationHanlder: nil, notificationHanlder: nil)
                    }
                    else {
                        _ = DateEvent(title: ekEvent.title, fullDayEvent: ekEvent.isAllDay, start: ekEvent.startDate, end: ekEvent.endDate, shouldRemind: ekEvent.hasAlarms, calendar: calendar, notes: ekEvent.notes, series: nil, reminder: nil, url: ekEvent.url, location: nil, locationHanlder: nil, notificationHanlder: nil)
                    }
                }
                
            }
            DispatchQueue.main.async {
                saveData()
                completionHandler(.done)
            }
        }
    }
    
    ///Fetches Events from the iOS calendar app
    public func fetchEKEvents(completionHandler: @escaping ([EKEvent], CompletionType) -> Void) {
        askForPermission(store: store){
            permission in
            guard permission == .done else {
                completionHandler([], permission)
                return
            }
            let calendars = self.store.calendars(for: .event)
            let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
            let inFourYears = Foundation.Calendar.current.date(byAdding: .year, value: 4, to: oneMonthAgo) ?? Date(timeIntervalSinceNow: 60*60*24*30)
            let predicate = self.store.predicateForEvents(withStart: oneMonthAgo, end: inFourYears, calendars: calendars)
            
            completionHandler(self.store.events(matching: predicate), .done)
        }
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
    
    private func getEKCalendar() -> EKCalendar {
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
    
    public func askForPermission(store: EKEventStore, completionHandler: @escaping (CompletionType) -> Void) {
        store.requestAccess(to: .event ) {
            res,error in
            if let error = error {
                print(error)
                completionHandler(.ekError)
                return
            }
            res ? completionHandler(.done) : completionHandler(.deniedPermission)
        }
        
        
    }
    
}
