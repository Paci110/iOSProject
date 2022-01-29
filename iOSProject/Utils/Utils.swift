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

func saveData(completionHanlder: (() -> Void)?) {
    let context = getContext()
    do {
        try context.save()
        
    } catch {
        if let completionHanlder = completionHanlder {
            completionHanlder()
        }
        else {
            print("Error in save data \(error)")
        }
    }
}

func deleteData(dataToDelete: NSManagedObject, completionHanlder: (() -> Void)?) {
    let context = getContext()
    context.delete(dataToDelete)
    saveData(completionHanlder: completionHanlder)
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


public enum WeekDay: Int {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, Undefined = -1
    
    var description: String {
        switch self.rawValue {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return "Undefined"
        }
    }
}

public func getWeekDay(weekDay: WeekDay) -> String {
    return ""
}

public func getWeekDay(date: Date) -> WeekDay {
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


public func applyTheme(theme: String){
    var settings = fetchSettings()
    
    switch(theme){
        case "Default": col = UIColor.systemBlue
        case "Mint": col = UIColor(red: 52.0/255, green: 238.0/255, blue: 219.0/255, alpha: 1)
        case "Scarlet": col = UIColor.systemRed
        case "Plum": col = UIColor(red: 160.0/255, green: 102.0/255, blue: 227.0/255, alpha: 1)
        default: ()
    }
    
    settings.colorTheme = theme
    
    saveData(completionHanlder: nil)
    
    print(settings)
}


public func fetchSettings() -> Settings {
    let context = getContext()
    
    var settings: [Settings]
    do {
        settings = try context.fetch(NSFetchRequest<Settings>(entityName: "Settings"))
        if(settings == []){
            settings = [Settings(colorTheme: "Default", startWithLastView: false, defaultView: "DayView")]
        }
    } catch {
        fatalError("couldn't fetch settings!")
    }
    
    return settings.first!
}
