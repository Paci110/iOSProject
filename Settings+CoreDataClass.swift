//
//  Settings+CoreDataClass.swift
//  iOSProject
//
//  Created by Pascal Köhler on 29.01.22.
//
//

import Foundation
import CoreData

@objc(Settings)
public class Settings: NSManagedObject {
    
    convenience init(colorTheme: String, startWithLastView: Bool, defaultView: String? = nil, showWeekNumbers: Bool) {
        self.init(context: getContext())
        
        self.colorTheme = colorTheme
        
        self.startWithLastView = startWithLastView
        
        self.defaultView = defaultView
        
        self.lastView = "Month View"
        
        self.showWeekNumbers = showWeekNumbers
        
    }

}
