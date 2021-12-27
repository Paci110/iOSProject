//
//  CalenderLogic.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import Foundation
import UIKit
//import CoreLocation

//MARK: Events
///Struct that is used to safe the information of a date event from a calender
struct DateEvent {
    let title: String
    var description: String?
    let fullDayEvent: Bool
    var start: Date
    var end: Date //The format of start and end should depend if it is a full day event
    var location: Any? //What Type should be used here?
    var shouldRemind: Bool
    var url: URL?
    var calendar: Calendar?
    
    init(Title title: String, Description description: String?, Start start: Date, End end: Date, ShouldRemind remind: Bool)
    {
        self.title = title
        self.description = description
        assert(start < end, "End date was beforee start date")
        self.start = start
        self.end = end
        self.shouldRemind = remind
        
        self.fullDayEvent = false
        self.url = nil
        self.calendar = nil
    }
    
    init(Title title: String, Description description: String?, FullDayEvent fullDayEvent: Bool, Start start: Date, End end: Date, ShouldRemind remind: Bool, URL url: URL?, Calendar calendar: Calendar?, Location location: Any?) {
        self.title = title
        self.description = description
        self.shouldRemind = remind
        self.url = url
        self.calendar = calendar
      
        self.fullDayEvent = fullDayEvent
        self.start = start
        if start > end {
            print("End date was before start date")
            self.end = start
        }
        else {
            self.end = end
        }
        
        if fullDayEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let startDateString = formatter.string(from: start) + " 0:00"
            self.start = getDate(fromString: startDateString)
            let endDateString = formatter.string(from: end) + " 23:59"
            self.end = getDate(fromString: endDateString)
        }
    }
    
    func getData() -> [Any] {
        var data: [Any] = []
        data.append(title)
        data.append(("Full day event", fullDayEvent))
        let format = "yyyy/MM/dd HH:mm"
        data.append(("Begin", getDate(FromDate: start, Format: format)))
        data.append(("End", getDate(FromDate: end, Format: format)))
        if let description = description {
            data.append(description)
        }
        if let url = self.url {
            data.append(url)
        }
        
        return data
    }
}

///String has to be of format "yyyy/MM/dd HH:mm"
func getDate(fromString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    if let date = formatter.date(from: fromString) {
        return date
    }
    return Date()
}

func getDate(FromDate fromDate: Date, Format format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: fromDate)
}

//MARK: Calendar
///Struct that is used to store and manage several Events
struct Calendar {
    var events: [DateEvent]
    let color: UIColor
    
    init(Color color: UIColor)
    {
        self.color = color
        
        //TODO: Load saved events via CoreData
        events = []
    }
    
    init(Color color: UIColor, Events events: [DateEvent])
    {
        self.color = color
        self.events = events
    }
}
