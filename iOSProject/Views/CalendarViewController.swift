//
//  CalendarViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 24.01.22.
//

import Foundation
import UIKit
import Combine
import CoreData

class CalendarViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var calendars: [Calendar]?
    
    var filteredCalendars: [Calendar]?
    
    var colorCancellable: AnyCancellable?
    
    @IBAction func saveButton(_ sender: Any) {
        saveData() {
            let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "calendarEdit", sender: Calendar(title: "New Calendar", color: UIColor.darkGray))
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        reloadData()
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func reloadData() {
        self.calendars = getCalendars()
        self.filteredCalendars = calendars
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getContext().rollback()
        
        let controller = self.navigationController?.topViewController

        if let controller = controller as? DayViewController {
            controller.reloadData()
        }
        if let controller = controller as? WeekViewController{
            controller.fetch()
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCalendars?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCustomCell") as! CalendarCustomCell
        /*
        cell.textLabel?.text = filteredCalendars![indexPath.row].title
        cell.imageView?.tintColor = filteredCalendars![indexPath.row].color
         */
        let calendar = filteredCalendars![indexPath.row]
        cell.calendar = calendar
        cell.title.text = calendar.title
        cell.imageLabel.tintColor = calendar.color
        cell.selectedButton.layer.cornerRadius = 0.5 * cell.selectedButton.bounds.size.width
        cell.selectedButton.layer.cornerCurve = .continuous
        cell.selectedButton.clipsToBounds = true
        if calendar.selected {
            cell.selectedButton.tintColor = .blue
        }
        else {
            cell.selectedButton.tintColor = .systemGray6
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? IndexPath, let dest = segue.destination as? CalendarEditViewController{
            dest.calendar = filteredCalendars![sender.row]
            dest.sender = self
        }
        
        if let sender = sender as? Calendar, let dest = segue.destination as? CalendarEditViewController {
            dest.calendar = sender
            dest.sender = self
        }
        
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
        }
    }
}

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "calendarEdit", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            [unowned self] action, view, completionHandler in
            let calendar = filteredCalendars![indexPath.row]
            
            if((calendar.dateEvents?.count ?? 0) > 0) {
                askToDelete(calendar, completionHandler)
            }else {
                deleteData(dataToDelete: calendar) {
                    let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func askToDelete(_ calendar: Calendar,_ completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Delete Calendar", message: "The calendar has events attached to it. Deleting the calendar will delete all attached events.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            _ in
            for event in calendar.dateEvents! {
                deleteData(dataToDelete: event as! NSManagedObject) {
                    let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            deleteData(dataToDelete: calendar) {
                let alert = UIAlertController(title: "Could not save changes", message: "The changes could not be saved. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
            self.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            _ in
            completionHandler(false)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CalendarViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let calendars = calendars else { return }
        filteredCalendars = searchText.isEmpty ? calendars : calendars.filter { (item: Calendar) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased())
        }
        self.refresh()
    }
}
