//
//  DayViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 19.12.21.
//

import UIKit
import MapKit

class DayViewController: UITableViewController {
    
    @IBOutlet weak var navigationItems: UINavigationItem!
    
    var dateEvents: [DateEvent]?
    var dateTitle: String?
    
    @IBAction func itemButtonClicked(_ sender: Any) {
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItems.title = dateTitle
        reloadData()
    }
    
    func reloadData() {
        dateEvents = getData(entityName: "DateEvent") as? [DateEvent]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add new element", message: "Please enter the name of the element you want to add", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            let textfield = alert.textFields![0]
            let start = Date()
            let end = Date()
            let calendar = Calendar(color: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
            if textfield.text == "" {
                textfield.text = "New DateEvent (title to short)"
            }
            let note = "This is a test note. This should be longer than a lable can hold."
            let url = URL(string: "www.rwth-aachen.de")
            let address = "Templergraben 57, 52062 Aachen"
            let date = DateEvent(title: textfield.text ?? "New DateEvent", fullDayEvent: true, start: start, end: end, shouldRemind: false, calendar: calendar, notes: note, url: url, address: address)
            print("Title: \(date.title)")
            print("Save data")
            saveData()
            let dat = getData(entityName: "DateEvent")
            print("Data count \(String(describing: dat?.count))")
            self.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: implement
        if let cell = sender as? DateEventCell,
           let dest = segue.destination as? DateViewController {
            dest.testDate = cell.dateEvent
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return dateEvents?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateEventCell", for: indexPath) as! DateEventCell
        cell.addInfo(dateEvent: dateEvents![indexPath.section])
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row \(indexPath.row), column \(indexPath.section)")
        let cell = self.tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "dateView", sender: cell)
    }
    
    //TODO: change?
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            [unowned self] action, view, completionHandler in
            let event: DateEvent = (tableView.cellForRow(at: indexPath) as! DateEventCell).dateEvent
            //self.tableView.deleteSections([indexPath.section], with: .left)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            //TODO: implement undo with popup
            deleteData(dataToDelete: event)
            reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
