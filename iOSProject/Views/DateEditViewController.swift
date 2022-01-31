//
//  DateEditViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 28.01.22.
//

import Foundation
import UIKit
import Combine
import CoreLocation

class DateEditViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var fulldaySwitch: UISwitch!
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderPicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var calendarPicker: UIPickerView!
    
    var date: Date?
    var dateEvent: DateEvent?
    var calendars: [Calendar]?
    var calendarCancellable: AnyCancellable?
    var sender: UIViewController? // The VC that made this vc pop up
    
    private var subscriber: AnyCancellable?
    
    @IBAction func saveButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let dateEvent = self.dateEvent {
                getContext().delete(dateEvent)
            }
            self.saveToDateEvent()
            if let dayView = self.sender as? DayViewController {
                dayView.reloadData()
            }
            if let dateView = self.sender as? DateViewController {
                dateView.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        getContext().rollback()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changeFullDaySwitch(_ sender: UISwitch) {
        guard sender.isOn else {
            return
        }
        let startOfDay = Foundation.Calendar.current.startOfDay(for: Date())
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Foundation.Calendar.current.date(byAdding: components, to: startOfDay)!
        
        startPicker.date = startOfDay
        endPicker.date = endOfDay
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.repeatPicker.reloadAllComponents()
            self.calendarPicker.reloadAllComponents()
        }
    }
    
    func reloadData() {
        titleTextField.text = dateEvent?.title
        fulldaySwitch.isOn = dateEvent?.fullDayEvent ?? false
        startPicker.date = dateEvent?.start ?? Date()
        endPicker.date = dateEvent?.end ?? Date()
        reminderSwitch.isOn = dateEvent?.shouldRemind ?? false
        //TODO: what to use next day or hour before?
        //reminderPicker.date = dateEvent?.reminder ?? Foundation.Calendar.current.date(byAdding: .day, value: 1, to: date ?? Date()) ?? Date()
        reminderPicker.date = dateEvent?.reminder ?? Foundation.Calendar.current.date(byAdding: .minute, value: -30, to: date ?? Date()) ?? Date()
        notesTextView.text = dateEvent?.notes ?? ""
        urlTextField.text = dateEvent?.url?.absoluteString ?? ""
        addressTextField.text = dateEvent?.place != nil ? "\(dateEvent?.place?.locality ?? ""), \(dateEvent?.place?.name ?? "")" : ""
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.calendars = getCalendars(filterFor: nil)
            self.refresh()
        }
        
        reloadData()
        
        //TODO: reminder, calendar, repeat
        self.repeatPicker.dataSource = self
        self.calendarPicker.dataSource = self
        
        self.repeatPicker.delegate = self
        self.calendarPicker.delegate = self
        
        if let date = date {
            startPicker.date = date
            endPicker.date = Foundation.Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? Calendar, let dest = segue.destination as? CalendarEditViewController{
            dest.calendar = sender
        }
    }
    
    func saveToDateEvent() {
        let title = self.titleTextField.text ?? "New event"
        let fullDayEvent = self.fulldaySwitch.isOn
        let start = self.startPicker.date
        let end = self.endPicker.date
        let notes = self.notesTextView.text == "" ? nil : self.notesTextView.text
        let url = self.urlTextField.text != nil ? URL(string: self.urlTextField.text!) : nil
        let shouldRemind = self.reminderSwitch.isOn
        let reminder = self.reminderPicker.date
        let calendar = self.calendars![self.calendarPicker.selectedRow(inComponent: 0)]
        var series: EventSeries? = nil
        if self.pickerView(self.repeatPicker, titleForRow: self.repeatPicker.selectedRow(inComponent: 1), forComponent: 1) != "Never"{
            
            let value = self.repeatPicker.selectedRow(inComponent: 0)+1
            
            let interval = self.repeatPicker.selectedRow(inComponent: 1)-1
            
            series = EventSeries(value: Int64(value), timeInterval: TimeInterval(rawValue: Int16(interval))!)
        }
        //Set the dateEvents place
        var address: String? = self.addressTextField.text
        if address == "" {
            address = nil
        }
        
        _ = DateEvent(title: title, fullDayEvent: fullDayEvent, start: start, end: end, shouldRemind: shouldRemind, calendar: calendar, notes: notes, series: series, reminder: reminder, url: url, address: address, locationHanlder: self.locationHandler, notificationHanlder: self.notificationHandler)
        
        saveData(completionHanlder: nil)
    }
    
    func locationHandler(success: Bool, error: Error?) {
        if let error = error {
            print(error)
        }
        guard success else {
            let alert = UIAlertController(title: "Location not found", message: "Location could not be found or an error occured", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.sender?.present(alert, animated: true, completion: nil)
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
                self.sender?.present(alert, animated: true, completion: nil)
            }
            return
        }
    }
    
}

extension DateEditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerView == self.repeatPicker ? 2 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.repeatPicker) {
            return component == 0 ? 30 : 6
        }
        return (calendars?.count ?? -1) + 1
    }
}

extension DateEditViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == self.repeatPicker) {
            guard component == 1 else { return String(row+1) } //Start at 1 because 0 is dumb
            guard row > 0 else { return "Never" }
            return TimeInterval(rawValue: Int16(row-1))?.description ?? "Error"
        }
        if(pickerView == self.calendarPicker) {
            return calendars!.count > row ? calendars![row].title : "Add Calendar"
        }
        return "\(component), \(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == self.calendarPicker else { return }
        if(self.pickerView(pickerView, titleForRow: row, forComponent: component) == "Add Calendar") {
            let cal = Calendar(title: "New Calendar", color: UIColor.cyan)
            performSegue(withIdentifier: "createCalendar", sender: cal)
            calendars!.append(cal)
            self.refresh()
            calendarCancellable = cal.publisher(for: \.title).sink() {value in
                print(value)
                DispatchQueue.main.async {
                    pickerView.reloadAllComponents()
                }
            }
        }
    }
}


