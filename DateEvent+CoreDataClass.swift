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
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind remind: Bool, calendar: Calendar, notes: String? = nil, url: URL? = nil, location: CLLocation? = nil) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        
        //TOOD: reminder and repeater
        
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
    
    ///Initialzator if user uses address for location
    /*
    convenience init(title: String, fullDayEvent: Bool, start: Date, end: Date, shouldRemind remind: Bool, calendar: Calendar, notes: String? = nil, url: URL? = nil, address: String) {
        //TODO: convert address to CLLocation and save it
        self.init(title: title, fullDayEvent: fullDayEvent, start: start, end: end, shouldRemind: shouldRemind, calendar: calendar, notes: notes, url: url)
        let geoCoder = CLGeocoder()
        var foundLocation: CLLocation? = nil
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                print("No such address found")
                return
            }
            foundLocation = location
        }
    }
     */
    
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
        if let url = self.url {
            data.append(url)
        }
        if let location = location {
            data.append(location)
        }
        
        return data
    }
}
