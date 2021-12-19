//
//  DateViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import UIKit

class DateViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Just for test purposes
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let start: Date = getDate(fromString: "2021/12/19 10:00")
        let end: Date = getDate(fromString: "2021/12/19 17:00")
        let dateEvent = DateEvent(Titel: "TestDate", FullDayEvent: true, Start: start, End: end)
    }
}
