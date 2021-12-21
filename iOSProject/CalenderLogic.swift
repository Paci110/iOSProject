//
//  CalenderLogic.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import Foundation
//import CoreLocation

///Struct that is used to safe the information of a date event from a calender
struct DateEvent {
    let title: String
    let fullDayEvent: Bool
    var start: Date
    var end: Date //The format of start and end should depend if it is a full day event
//    var place: CLLocation
    
    //TODO place, map, reminder
    
    init(Title title: String, FullDayEvent fullDayEvent: Bool, Start start: Date, End end: Date) {
        self.title = title
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
    
    func getData() -> [String] {
        var data: [String] = []
        data.append(title)
        let format = "yyyy/MM/dd HH:mm"
        data.append(getDate(FromDate: start, Format: format))
        data.append(getDate(FromDate: end, Format: format))
        if fullDayEvent {
            data.append("Full day event")
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
