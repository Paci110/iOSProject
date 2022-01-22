//
//  CHelp.swift
//  iOSProject
//
//  Created by Anastasiia Petrova on 22.01.22.
//

import Foundation
import UIKit

class CHelp
{
    let calendar = NSCalendar.current
    
    
    func toStringMonth(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func toStringYear(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func selectDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func addMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func whichWeekday(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func removeMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func addYear(date: Date) -> Date
    {
        return calendar.date(byAdding: .year, value: 1, to: date)!
    }
    
    func removeYear(date: Date) -> Date
    {
        return calendar.date(byAdding: .year, value: -1, to: date)!
    }
    
    func howManyDaysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func selectFirst(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
}
