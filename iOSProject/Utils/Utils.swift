import Foundation
import UIKit
import CoreData

public let dateFormat = "dd/MM/yyyy HH:mm"

///Returns the weekday from a given string that is expected in the default format
func getWeekDay(date dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let date = formatter.date(from: dateString)!
    formatter.locale = Locale(identifier: "en")
    formatter.dateFormat = "EEEE"
    let weekday = formatter.string(from: date)
    return weekday
}

///String has to be of format "yyyy/MM/dd HH:mm"
func getDate(fromString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    if let date = formatter.date(from: fromString) {
        return date
    }
    return Date()
}

func getDate(FromDate fromDate: Date, Format format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en")
    return formatter.string(from: fromDate)
}

func getContext() -> NSManagedObjectContext {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
func saveData() {
    let context = getContext()
    do {
        try context.save()
        
    } catch {
        //TODO: show message box with error
        print("Error in save data \(error)")
    }
}

func deleteData(dataToDelete: NSManagedObject) {
    let context = getContext()
    context.delete(dataToDelete)
    saveData()
}

func getData(entityName: String) -> [Any]? {
    let context = getContext()
    var a: [Any]?
    do {
        //NSFetchRequest(entityName: entityName).predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
        a = try context.fetch(NSFetchRequest(entityName: entityName))
    } catch {
        print("Error in get data \(error)")
    }
    return a;
}

/*
public func getWeekDay(date: Date) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    
    switch(dateFormatter.string(from: date)) {
    case "Monday":
        return 0
    case "Tuesday":
        return 1
    case "Wednesday":
        return 2
    case "Thursday":
        return 3
    case "Friday":
        return 4
    case "Saturday":
        return 5
    case "Sunday":
        return 6
    default:
        return -1
    }
}
*/


public enum WeekDay:Int {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, Undefined = -1
}

public func getWeekDay(date: Date) -> WeekDay{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    
    switch(dateFormatter.string(from: date)) {
    case "Monday":
        return .Monday
    case "Tuesday":
        return .Tuesday
    case "Wednesday":
        return .Wednesday
    case "Thursday":
        return .Thursday
    case "Friday":
        return .Friday
    case "Saturday":
        return .Saturday
    case "Sunday":
        return .Sunday
    default:
        return .Undefined
    }
}


public func dateToDMY (date: Date) -> [Int] {
    let dateString = getDate(FromDate: date, Format: "dd/MM/yyyy")
    let DMY = dateString.split(separator: "/")
    
    var IntDMY: [Int] = []
    for i in DMY{
        IntDMY.append(Int(i)!)
    }
    
    return IntDMY
}
