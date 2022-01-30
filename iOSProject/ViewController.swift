//
//  ViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 16.12.21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let theme = fetchSettings().colorTheme
        applyTheme(theme: theme)
        UIView.appearance().tintColor = col
        view.window?.tintColor = col
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = (segue.destination) as? DateViewController {
            let dateEvents = getData(entityName: "DateEvent")
            print(dateEvents!.count)
            if let dateEvents = dateEvents, !dateEvents.isEmpty, let dateEvent = dateEvents[0] as? DateEvent {
                print("Works")
                dest.dateEvent = dateEvent
            }
            else {
                print("Fetch went wrong")
            }
        }
        if let dest = (segue.destination) as? DayViewController {
            //TODO: hand over the correct date to display
            dest.date = Date()
        }
        
        if let dest = (segue.destination) as? WeekViewController {
            dest.setDays(dateInWeek: Date())
        }
        
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
        }
    }
    
    @IBAction func unwindToExampleView(_ segue: UIStoryboardSegue) {
        if let navMenu = segue.source as? NavigationMenuController,
           let segueIdentifier = navMenu.segueIdentifier {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
    }
    
}
