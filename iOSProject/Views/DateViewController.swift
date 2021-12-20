//
//  DateViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import UIKit
import CoreLocation

class DateViewController: UIViewController {
    
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDateInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Just for test purposes
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let start: Date = getDate(fromString: "2021/12/19 10:00")
        let end: Date = getDate(fromString: "2021/12/19 17:00")
//        let place: CLLocation = CLLocation(latitude: 29, longitude: 10)
        let dateEvent = DateEvent(Title: "TestDate", FullDayEvent: true, Start: start, End: end)
        
        //Show sample Data
        labelDateTitle.text = dateEvent.title
        formatter.dateFormat = "HH:mm, dd/MM/yyyy"
        labelDateInfo.text = "Aachen, \(dateEvent.start.formatted()) - \(dateEvent.end.formatted())"
    }
}
