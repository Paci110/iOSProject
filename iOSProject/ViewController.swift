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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = (segue.destination) as? DateViewController {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let start: Date = getDate(fromString: "2021/12/19 10:00")
            let end: Date = getDate(fromString: "2021/12/19 17:00")
            //let place: CLLocation = CLLocation(latitude: 29, longitude: 10)
            let note = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
            let url = URL(string: "www.rwth-aachen.de")
            //var address: CLLocation? = nil
            //let geocoder = CLGeocoder()
            
            /*
            geocoder.geocodeAddressString("Templergraben 57, 52062 Aachen, Germany") { (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard
                    let placemarks = placemarks,
                    let tempAdress = placemarks.first?.location
                else {
                    print("No location with given adress string found")
                    return
                }
                //print(tempAdress)
                address = tempAdress
            }
             */
            
            let calendar = Calendar(color: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
            //let dateEvent = DateEvent(title: "Test Date", fullDayEvent: true, start: start, end: end, shouldRemind: false, calendar: calendar, notes: note, url: url, location: CLLocation(latitude: 50.77828170, longitude: 6.07847850))
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
            dest.dateTitle = "Sa, 15.01.2022"
        }
    }

}
