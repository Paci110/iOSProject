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
        // Do any additional setup after loading the view.
        EKUtils().loadEKEvents(completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = (segue.destination) as? DateViewController {
            let dateEvents = getData(entityName: "DateEvent")
            print(dateEvents!.count)
            if let dateEvents = dateEvents, !dateEvents.isEmpty, let dateEvent = dateEvents[0] as? DateEvent {
                print("Works")
                dest.testDate = dateEvent
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
    }

}
