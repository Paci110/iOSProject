//
//  Calendar+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 14.01.22.
//
//

import Foundation
import CoreData
import UIKit


public class Calendar: NSManagedObject {
    
    convenience init(title: String, color: UIColor) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        self.title = title
        self.color = color
        self.selected = true
    }
    
    convenience init(title: String, color: UIColor, dateEvents: [DateEvent]) {
        self.init(title: title, color: color)
        for dateEvent in dateEvents {
            self.addToDateEvents(dateEvent)
        }
    }
}
