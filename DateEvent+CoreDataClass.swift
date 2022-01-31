//
//  DateEvent+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 14.01.22.
//
//

import Foundation
import CoreData
import MapKit
import UserNotifications

public class DateEvent: NSManagedObject {
    
    ///Creates a new dateEvent with the given arguements. Optional arguements that are not specified are set to nil.
    ///Checks if beginning and ending date are set correctly.
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind remind: Bool, calendar: Calendar, notes: String? = nil, series: EventSeries? = nil, reminder: Date? = nil, url: URL? = nil, location: CLLocation? = nil, locationHanlder: ((Bool, Error?) -> Void)?, notificationHanlder: ((Bool, Error?) -> Void)?) {
        let context = getContext()
        self.init(context: context)
        
        //TOOD: reminder and repeater
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    guard let locationHanlder = locationHanlder else {
                        return
                    }
                    
                    locationHanlder(false, error)
                    print(error)
                    return
                }
                guard
                    let placemarks = placemarks,
                    let first = placemarks.first
                else {
                    guard let locationHanlder = locationHanlder else {
                        return
                    }
                    
                    locationHanlder(false, nil)
                    print("No such address found")
                    return
                }
                self.place = first
                //TODO: Has to update somewhere else
                //                saveData()
                guard let locationHanlder = locationHanlder else {
                    return
                }
                
                locationHanlder(true, nil)
            }
        }
        
        self.title = title
        self.notes = notes
        self.shouldRemind = remind
        self.reminder = reminder
        if shouldRemind, let reminder = reminder {
            let notiCenter = UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert]) { (auth, error) in
                if let error = error {
                    guard let notificationHanlder = notificationHanlder else {
                        return
                    }
                    notificationHanlder(false, error)
                    return
                }
                guard auth else {
                    self.shouldRemind = false
                    guard let notificationHanlder = notificationHanlder else {
                        return
                    }
                    
                    notificationHanlder(false, nil)
                    print("Not authorized")
                    let alert = UIAlertController(title: "Notifications not allowed", message: "Please enable notfications in the settings. Reminder will be deactivated for this event.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    //FIXME: display user warning in displayed view
                    /*
                     let viewCon = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
                     viewCon?.present(alert, animated: true, completion: nil)
                     */
                    DayViewController().present(alert, animated: true, completion: nil)
                    return
                }
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = notes ?? ""
                
                let calendar = NSCalendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminder)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let id = UUID().uuidString
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                let notiCenter = UNUserNotificationCenter.current()
                notiCenter.add(request) { error in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                }
                guard let notificationHanlder = notificationHanlder else {
                    return
                }
                
                notificationHanlder(true, nil)
            }
        }
        self.url = url
        self.calendar = calendar
        self.series = series
        
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
        //FIXME: Start and End are not set to what is expected (00:00 and 23:59). Instead,it is the start and end given in the parameters, but 1 hour early.
        if fullDayEvent {
            let startDateString = getDate(FromDate: start, Format: "DD.MM.YYYY") + " 0:00"
            self.start = getDate(fromString: startDateString)
            let endDateString = getDate(FromDate: end, Format: "DD.MM.YYYY") + " 23:59"
            self.end = getDate(fromString: endDateString)
            
            print(startDateString)
            print(endDateString)
            print(start)
            print(end)
        }
        
        self.calendar.addToDateEvents(self)
    }
    
    ///Initialzator if user uses address for location
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind: Bool, calendar: Calendar, notes: String? = nil, series: EventSeries? = nil, reminder: Date? = nil, url: URL? = nil, address: String?, locationHanlder: ((Bool, Error?) -> Void)?, notificationHanlder: ((Bool, Error?) -> Void)?) {
        self.init(title: title, fullDayEvent: fullDayEvent, start: start, end: end, shouldRemind: shouldRemind, calendar: calendar, notes: notes, series: series, reminder: reminder, url: url, locationHanlder: nil, notificationHanlder: notificationHanlder)
        if let address = address {
            CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    guard let locationHanlder = locationHanlder else {
                        return
                    }
                    
                    locationHanlder(false, error)
                    print(error)
                    return
                }
                guard
                    let placemarks = placemarks,
                    let first = placemarks.first
                else {
                    guard let locationHanlder = locationHanlder else {
                        return
                    }
                    
                    locationHanlder(false, nil)
                    print("No such address found")
                    return
                }
                
                self.place = first
                saveData(completionHanlder: nil)
                
                guard let locationHanlder = locationHanlder else {
                    return
                }
                
                locationHanlder(true, nil)
            }
        }
    }
    
    ///Returns array of all used arguements with some additional display informations
    func getData() -> [Any] {
        var data: [Any] = []
        data.append(title)
        data.append(("Full day event", fullDayEvent))
        let format = dateFormat
        data.append(("Start", getDate(FromDate: start, Format: format)))
        data.append(("End", getDate(FromDate: end, Format: format)))
        data.append(calendar)
        if let notes = notes {
            data.append(notes)
        }
        if let series = series {
            data.append(series)
        }
        if let reminder = reminder {
            data.append(reminder)
        }
        if let url = self.url {
            data.append(url)
        }
        if let place = place {
            data.append(place)
        }
        
        return data
    }
}
