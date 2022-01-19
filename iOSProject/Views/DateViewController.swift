//
//  DateViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import UIKit
import CoreLocation
import MapKit

class DateViewController: UIViewController {
    
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var tableViewDates: UITableView!
    
    var testDate: DateEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDates.delegate = self
        tableViewDates.dataSource = self
        
        labelDateTitle.text = testDate?.title
    }
    
    
}

extension DateViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let testDate = testDate else {
            return 0
        }

        var sections = testDate.getData().count
        sections -= 1 //Exclude title from table view
        sections -= 2 //Group first 3 date segments in on section
        return sections
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            //TODO: first header is not displayed correctly
            //return "Time"
        }
        let data = testDate?.getData()[section+3]
        
        if (data as? (String)) != nil
        {
            return "Notes"
        }
        else if (data as? (URL)) != nil
        {
            return "URL"
        }
        else if (data as? (CLLocation)) != nil
        {
            return "Map"
        }
        return ""
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
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
        else if let data = dateText as? URL {
            //TODO: clickable link
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            let linkString = NSAttributedString(string: data.absoluteString, attributes: [NSAttributedString.Key.link: data])
            cell.textLabel?.attributedText = linkString
            cell.textLabel?.isUserInteractionEnabled = true
            return cell
        }
        else if let data = dateText as? CLPlacemark {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
            let region = MKCoordinateRegion.init(center: data.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
            cell.mapView.setRegion(region, animated: false)
            cell.mapView.mapType = .standard
            
            let marker = MKPointAnnotation()
            marker.title = data.name
            marker.coordinate = data.location!.coordinate
            cell.mapView.addAnnotation(marker)
            
            return cell
        }
        else if let data = dateText as? EventSeries {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.textLabel?.text = "Repeating every \(data.value) \(data.timeInterval)"
            return cell
        }
        else if let data = dateText as? Date {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            var dateBetween = testDate!.start.distance(to: data)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .abbreviated
            let additionStr = dateBetween < 0 ? "before" : "after"
            if dateBetween < 0 {
                dateBetween.negate()
            }
            let str = "Reminder: \(formatter.string(from: dateBetween)!)"
            cell.textLabel?.text = "\(str) \(additionStr)"
            return cell
        }
        else if let data = dateText as? Calendar {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
            cell.backgroundColor = data.color
            cell.textLabel?.text = data.title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) //Add any cell?
            cell.textLabel?.text = "Sample Text"
            return cell
        }
    }
}

extension DateViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row \(indexPath.row), column \(indexPath.section)")
    }
}
