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


public class DateEvent: NSManagedObject {
    
    ///Creates a new dateEvent with the given arguements. Optional arguements that are not specified are set to nil.
    ///Checks if beginning and ending date are set correctly.
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind remind: Bool, calendar: Calendar, notes: String? = nil, series: EventSeries? = nil, reminder: Date? = nil, url: URL? = nil, location: CLLocation? = nil) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        //TOOD: reminder and repeater
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard
                    let placemarks = placemarks,
                    let first = placemarks.first
                else {
                    print("No such address found")
                    return
                }
                self.place = first
                saveData()
            }
        }
        
        self.title = title
        self.notes = notes
        self.shouldRemind = remind
        self.url = url
        self.calendar = calendar
        self.series = series
        self.reminder = reminder
        
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
    }
    
    ///Initialzator if user uses address for location
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind: Bool, calendar: Calendar, notes: String? = nil, series: EventSeries? = nil, reminder: Date? = nil, url: URL? = nil, address: String) {
        //TODO: update current view after lcoation is fetshed?
        self.init(title: title, fullDayEvent: fullDayEvent, start: start, end: end, shouldRemind: shouldRemind, calendar: calendar, notes: notes, series: series, reminder: reminder, url: url)
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard
                let placemarks = placemarks,
                let first = placemarks.first
            else {
                print("No such address found")
                return
            }
            self.place = first
            saveData()
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
