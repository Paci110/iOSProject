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
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return reminderData.count
        }
        return reminderWordsData.count
      
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return reminderData[row]
        }
        
        return reminderWordsData[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("\(reminderData[row])")?
        let a = "\(reminderData[row])"
        
        
        print (a)
    }
    
    
    let reminderData = ["1","2","3","4","5","6","7"]
    let reminderWordsData = ["without" , "min before" , "hour before" , "day(s) before" ,"week(s) before", "year(s) before"]
    

    @IBOutlet weak var fullDaySwitch : UISwitch?
    @IBOutlet weak var chooseStartTime : UIDatePicker!
    @IBOutlet weak var chooseEndTime : UIDatePicker!
    @IBOutlet weak var titleNote : UITextField!
    @IBOutlet weak var note : UITextView!
    @IBOutlet weak var URL : UITextField!
    @IBOutlet weak var Address : UITextField!
    @IBOutlet weak var reminder : UIPickerView!
    
  
    
    //var reminderData : [String] = [String]()
    //var reminderWordsData : [String] = [String]()
    
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
        
        
       
        
        setReminder()
    }
    
    
    func setReminder() {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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




