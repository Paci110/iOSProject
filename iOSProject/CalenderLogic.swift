//
//  CalenderLogic.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import Foundation

///Struct that is used to safe the information of a date event from a calender
struct DateEvent {
    let titel: String
    let fullDayEvent: Bool
    var start: Date
    var end: Date //The format of start and end should depend if it is a full day event
    
    //TODO place, map, reminder
    
    init(Titel titel: String, FullDayEvent fullDayEvent: Bool, Start start: Date, End end: Date) {
        self.titel = titel
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
}

func getDate(fromString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    if let date = formatter.date(from: fromString) {
        return date
    }
    return Date()
}
