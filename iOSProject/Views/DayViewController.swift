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
    
    override func viewDidAppear(_ animated: Bool) {
        let theme = fetchSettings().colorTheme
        applyTheme(theme: theme)
        UIView.appearance().tintColor = col
        view.window?.tintColor = col
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
            self.dateLabel.text = getDate(FromDate: self.date!, Format: "EE, d.MM.yyyy")
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        //TODO: Give default calendar
        let calendar = Calendar(title: "Sample Calendar", color: UIColor.orange)
        let event = DateEvent(title: "New Event", fullDayEvent: false, start: Date(), end: Date(), shouldRemind: false, calendar: calendar, notes: nil, series: nil, reminder: nil, url: nil, location: nil, locationHanlder: nil, notificationHanlder: nil)
        performSegue(withIdentifier: "editSegue", sender: event)
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
        if let cell = sender as? DateEventCell,
           let dest = segue.destination as? DateViewController {
            dest.dateEvent = cell.dateEvent
            dest.sender = self
        }
        if let sender = sender as? DateEvent, let dest = segue.destination as? DateEditViewController {
            dest.dateEvent = sender
            dest.sender = self
            dest.date = date
        }
        
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
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
            let AnotherController = storyBoard.instantiateViewController(withIdentifier: "monthView") as! MonthViewController
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
    
    @IBAction func unwindToDay(_ segue: UIStoryboardSegue) {
    }
}
