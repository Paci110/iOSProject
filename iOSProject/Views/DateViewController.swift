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
        //let place: CLLocation = CLLocation(latitude: 29, longitude: 10)
        let note = "This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description. This is a test description."
        let dateEvent = DateEvent(Title: "Test Date", Description: note, FullDayEvent: true, Start: start, End: end, ShouldRemind: false, URL: nil, Calendar: nil, Location: nil)
        testDate = dateEvent
        
        labelDateTitle.text = testDate?.title
    }
}

extension UIViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let testDate = testDate else {
            return 0
        }

        var sections = testDate.getData().count
        sections -= 1 //Exclude title from table view
        sections -= 2 //Group first 3 date segments in on section
        return sections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var prevRows = 1
        for i in 0...indexPath.section {
            prevRows += tableView.numberOfRows(inSection: i)
        }
        prevRows -= tableView.numberOfRows(inSection: indexPath.section)
        let dateText = testDate?.getData()[prevRows + indexPath.row]
        if let data = dateText as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.textLabel?.text = data
            return cell
        }
        else if let data = dateText as? (String, String) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptiveTextCell", for: indexPath)
            cell.textLabel?.text = data.0
            cell.detailTextLabel?.text = data.1
            return cell
        }
        else if let data = dateText as? (String, Bool) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoolCell", for: indexPath) as! BoolCell
            cell.lableObject.text = data.0
            let state = data.1
            cell.switchObject.setOn(state, animated: true)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Any", for: indexPath)
            return cell
        }
    }
}

extension UIViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row \(indexPath.row), column \(indexPath.section)")
    }
}
