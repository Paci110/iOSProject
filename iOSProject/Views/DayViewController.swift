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
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateEvents: [DateEvent]?
    var date: Date?
    
    @IBAction func todayButtonClicked(_ sender: UIBarButtonItem) {
        jumpToToday()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (date == nil) {
            print("No date provided. Using current date")
            date = Date()
        }
        
        //Add the left and right swipe recognizer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeLeft.direction = .left
        
        // add Pinch
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(respondToPinch))
        
        self.view.addGestureRecognizer(pinchGesture)
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        reloadData()
    }
    
    func reloadData() {
        //dateEvents = getDay(day: 19, month: 1, year: 2022)
        let dmy = dateToDMY(date: date!)
        dateEvents = getDay(day: dmy[0], month: dmy[1], year: dmy[2])
        
        //navigationItems.title = getDate(FromDate: date!, Format: "EE, DD.MM.YYYY")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.dateLabel.text = getDate(FromDate: self.date!, Format: "EE, DD.MM.YYYY")
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add new element", message: "Please enter the name of the element you want to add", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
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
            let reminder = Date(timeIntervalSinceNow: 10)
            _ = DateEvent(title: textfield.text ?? "New DateEvent", fullDayEvent: false, start: start, end: end, shouldRemind: true, calendar: calendar, notes: note, series: eventSeries, reminder: reminder, url: url, address: address, locationHanlder: self.locationHandler, notificationHanlder: self.notificationHandler)
            
            print("Save data")
            
            saveData() {
                let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
                                
            let dat = getData(entityName: "DateEvent")
            print("Data count \(String(describing: dat?.count))")
            self.reloadData()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationHandler(success: Bool, error: Error?) {
        if let error = error {
            print(error)
        }
        guard success else {
            let alert = UIAlertController(title: "Location not found", message: "Location could not be found or an error occured", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        reloadData()
    }
    
    func notificationHandler(success: Bool, error: Error?) {
        if let error = error {
            print(error)
        }
        guard success else {
            let alert = UIAlertController(title: "Notifications not allowed", message: "Please enable notfications in the settings. Reminder will be deactivated for this event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
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
            deleteData(dataToDelete: event) {
                let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
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
    
    @objc func respondToPinch(gesture: UIGestureRecognizer){
        guard let pinchGesture = gesture as? UIPinchGestureRecognizer else {return}
        //view.backgroundColor = .green
        //scale can be changed here
        if (pinchGesture.scale >= CGFloat(2)) {
            //view.backgroundColor = .black
            
            //get controller from StoryBoard
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AnotherController = storyBoard.instantiateViewController(withIdentifier: "monthViewController") as! MonthViewController
            self.navigationController?.pushViewController(AnotherController, animated: false)
            return
        }
    }
   
    private func jumpToToday()
    {
        self.date = Date()
        reloadData()
    }
   
    @IBAction func nextDay(_ sender: Any) {
        self.date = Foundation.Calendar.current.date(byAdding: .day, value: 1, to: self.date!)
        reloadData()
    }
  
    @IBAction func prevDay(_ sender: Any) {
        self.date = Foundation.Calendar.current.date(byAdding: .day, value: -1, to: self.date!)
        reloadData()
    }
}
