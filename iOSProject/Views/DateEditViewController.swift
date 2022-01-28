//
//  DateEditViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 28.01.22.
//

import Foundation
import UIKit

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
    
    var dateEvent: DateEvent?
    var calendars: [Calendar]?
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveData()
        //TODO: go back to previous vc
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        //TODO: go back to previous vc
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.repeatPicker.reloadAllComponents()
            self.calendarPicker.reloadAllComponents()
        }
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.calendars = getCalendars(filterFor: nil)
            self.refresh()
        }
        
        
        titleTextField.text = dateEvent?.title
        fulldaySwitch.isOn = dateEvent?.fullDayEvent ?? false
        startPicker.date = dateEvent?.start ?? Date()
        endPicker.date = dateEvent?.end ?? Date()
        reminderSwitch.isOn = dateEvent?.shouldRemind ?? false
        reminderPicker.date = dateEvent?.reminder ?? Foundation.Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        notesTextView.text = dateEvent?.notes ?? ""
        urlTextField.text = dateEvent?.url?.absoluteString ?? ""
        addressTextField.text = dateEvent?.place != nil ? "\(dateEvent?.place?.locality ?? ""), \(dateEvent?.place?.name ?? "")" : ""
        
        //TODO: reminder, calendar, repeat
        self.repeatPicker.dataSource = self
        self.calendarPicker.dataSource = self
        
        self.repeatPicker.delegate = self
        self.calendarPicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? Calendar, let dest = segue.destination as? CalendarEditViewController{
            dest.calendar = sender
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
            //TODO: Refresh doesnt work
            _ = cal.publisher(for: \.title).sink() {value in
                print(value)
                DispatchQueue.main.async {
                    pickerView.reloadAllComponents()
                    pickerView.selectRow(0, inComponent: component, animated: true)
                    pickerView.selectRow(row, inComponent: component, animated: true)
                }
            }
        }
    }
}


