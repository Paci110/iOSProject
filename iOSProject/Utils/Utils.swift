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
    return formatter.string(from: fromDate)
}

/*
func saveData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            //TODO: show message box with error
            print("Error in save data \(error)")
        }
    }
}
 */

private func getContext() -> NSManagedObjectContext {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

func saveData() {
    let context = getContext()
    do {
        try context.save()
    } catch {
        print("Error in save data \(error)")
    }
}

func deleteData(dataToDelete: NSManagedObject) {
    let context = getContext()
    context.delete(dataToDelete)
    saveData()
}

func getData(entityName: String) -> [Any]? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var a: [Any]?
    do {
        //NSFetchRequest(entityName: entityName).predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
        a = try context.fetch(NSFetchRequest(entityName: entityName))
    } catch {
        print("Error in get data \(error)")
    }
    return a;
}
