//
//  DateEditViewController.swift
//  iOSProject
//
//  Created by Tony-Trung Luu Zelinski on 22.01.22.
//
import Foundation
import UIKit


class DateEditViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(reminderData[row])")
            
    }
    
    
    

    @IBOutlet weak var fullDaySwitch : UISwitch?
    @IBOutlet weak var chooseStartTime : UIDatePicker!
    @IBOutlet weak var chooseEndTime : UIDatePicker!
    @IBOutlet weak var titleNote : UITextField!
    @IBOutlet weak var note : UITextView!
    @IBOutlet weak var URL : UITextField!
    @IBOutlet weak var Address : UITextField!
    @IBOutlet weak var reminder : UIPickerView!
  
    
    var reminderData : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSetting()
        note.text = "Notes and URL"
        note.textColor = .lightGray
        note.delegate = self
       
        urlSetting()
        addressSetting()
        
        self.reminder.delegate = self
        self.reminder.dataSource = self
        
        reminderData = ["wihout" , "5 min before" , "10 min before" , "15 min before" , "30 min before" , "1 hour before" , "2 hours before" , "1 day before" , "2 days before" , "1 week before"]
        
    }
    
    func setReminder() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if note.text == "Notes and URL" {
            note.text = ""
            note.textColor = .black
            //note.backgroundColor = .lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if note.text == "" {
            note.text = "Notes and URL"
            note.textColor = .lightGray
            note.backgroundColor = .white
            
        }
    }
    
    private func titleSetting() {
        titleNote.delegate = self
        titleNote.becomeFirstResponder()
        titleNote.returnKeyType = .done
        titleNote.autocorrectionType = .yes
        titleNote.autocapitalizationType = .words
        titleNote.placeholder = "Title"
        
    }
    
    private func urlSetting() {
        URL.delegate = self
        URL.returnKeyType = .done
        URL.autocorrectionType = .no
        URL.placeholder = "URL"
    }
    
    private func addressSetting() {
        Address.delegate = self
        Address.returnKeyType = .done
        Address.placeholder = "Address"
    }
    
 
    @IBAction func fullDaySwitch(_ sender: UISwitch) {
            if sender.isOn{
                titleNote.resignFirstResponder()
                let currentDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "DD.MM.YYYY"
                let startDateString = formatter.string(from: currentDate) + " 0:00"
                let endDateString = formatter.string(from: currentDate) + " 23:59"
                let startdate = getDate(fromString: startDateString)
                let enddate = getDate(fromString: endDateString)
                chooseStartTime.setDate(startdate, animated: true)
                chooseEndTime.setDate(enddate, animated: true)
                
            }
    }
    

            
                
                
        // Do any additional setup after loading the view.
        
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*extension DateEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }
}*/




