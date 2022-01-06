//
//  Calendar+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 06.01.22.
//
//

import Foundation
import CoreData
import UIKit

public class Calendar: NSManagedObject {
    
    convenience init(color: UIColor) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
        self.color = color
    }
    
    convenience init(color: UIColor, dateEvents: [DateEventCoreData]) {
        self.init(color: color)
        for dateEvent in dateEvents {
            self.addToDateEvents(dateEvent)
        }
    }

}
