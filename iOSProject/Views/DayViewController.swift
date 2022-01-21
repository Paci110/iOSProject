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
    var date: Date?
    
    /*
    //Priorises this view as responder
    override canBecomeFirstResponder {
        get {return true}
    }
    */
    
    @IBAction func todayButtonClicked(_ sender: UIBarButtonItem) {
        jumpToToday()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if date == nil {
            print("No date provided. Using current date")
            date = Date()
        }
        
        //Add the left and right swipe recognizer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeLeft.direction = .left

        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        reloadData()
    }
    
    func reloadData() {
        //dateEvents = getDay(day: 19, month: 1, year: 2022)
        let dmy = dateToDMY(date: date!)
        dateEvents = getDay(day: dmy[0], month: dmy[1], year: dmy[2])
        
        navigationItems.title = getDate(FromDate: date!, Format: "EE, DD.MM.YYYY")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add new element", message: "Please enter the name of the element you want to add", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            let textfield = alert.textFields![0]
            let start = self.date!
            let end = self.date!
            let calendar = Calendar(title: "TestCalendar", color: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
            if textfield.text == "" {
                textfield.text = "New DateEvent (title to short)"
            }
            let note = "This is a test note. This should be longer than a lable can hold."
            let url = URL(string: "www.rwth-aachen.de")
            let address = "Templergraben 57, 52062 Aachen"
            let eventSeries = EventSeries(value: 10, timeInterval: TimeInterval.Day)
            let reminder = Date(timeIntervalSinceNow: -300000)
            _ = DateEvent(title: textfield.text ?? "New DateEvent", fullDayEvent: false, start: start, end: end, shouldRemind: false, calendar: calendar, notes: note, series: eventSeries, reminder: reminder, url: url, address: address)
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(motion == .motionShake)
        {
            jumpToToday()
        }
    }
    
    @objc func respondToSwipe(gesture: UIGestureRecognizer)
    {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {return}

        switch swipeGesture.direction {
        case .right:
            //Jump to the previous day
            self.date = Foundation.Calendar.current.date(byAdding: .day, value: -1, to: self.date!)
            reloadData()
        case .left:
            //Jump to the next day
            self.date = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: self.date!)
            reloadData()
        default:
            break
        }
    }
    
    private func jumpToToday()
    {
        self.date = Date()
        reloadData()
    }
}
