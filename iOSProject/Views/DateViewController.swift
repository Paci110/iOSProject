//
//  DateViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import UIKit
import CoreLocation

var testDate: DateEvent?

class DateViewController: UIViewController {
    
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDateInfo: UILabel!
    @IBOutlet weak var tableViewDates: UITableView!
    
    public func getTestDate() -> DateEvent? {
        return testDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDates.delegate = self
        tableViewDates.dataSource = self
        
        //Just for test purposes
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let start: Date = getDate(fromString: "2021/12/19 10:00")
        let end: Date = getDate(fromString: "2021/12/19 17:00")
        //        let place: CLLocation = CLLocation(latitude: 29, longitude: 10)
        let dateEvent = DateEvent(Title: "TestDate", Description: nil, FullDayEvent: true, Start: start, End: end, ShouldRemind: false, URL: nil, Calendar: nil, Location: nil)
        testDate = dateEvent
        
        //Show sample Data
        labelDateTitle.text = dateEvent.title
        formatter.dateFormat = "HH:mm, dd/MM/yyyy"
        labelDateInfo.text = "Aachen, \(dateEvent.start.formatted()) - \(dateEvent.end.formatted())"
        
    }
}

extension UIViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return testDate?.getData().count ?? 0
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
        let dateText = testDate?.getData()[indexPath.row]
        cell.textLabel?.text = dateText
        return cell
    }
}

extension UIViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row \(indexPath.row), column \(indexPath.section)")
    }
}
