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
    
    convenience init(colorTheme: String, startWithLastView: Bool, defaultView: String? = nil) {
        self.init(context: getContext())
        
        switch colorTheme {
        case "first theme":
            self.colorTheme = colorTheme
        default:
            self.colorTheme = "default theme"
        }
        
        print(self.colorTheme)
        
        self.startWithLastView = startWithLastView
        
        self.defaultView = defaultView
        
        self.lastView = "Month View"
        
    }

}
