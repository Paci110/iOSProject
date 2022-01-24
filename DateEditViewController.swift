//
//  DateEditViewController.swift
//  iOSProject
//
//  Created by Tony-Trung Luu Zelinski on 22.01.22.
//
import Foundation
import UIKit


class DateEditViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var fullDaySwitch : UISwitch?
    @IBOutlet weak var chooseStartTime : UIDatePicker!
    @IBOutlet weak var chooseEndTime : UIDatePicker!
    @IBOutlet weak var titleNote : UITextField!
    @IBOutlet weak var note : UITextView!
    @IBOutlet weak var reminder : UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleSetting()
        note.text = "Notes and URL"
        note.textColor = .lightGray
        note.delegate = self
        
        
    
        }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if note.text == "Notes and URL" {
            note.text = ""
            note.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if note.text == "" {
            note.text = "Notes and URL"
            note.textColor = .lightGray
            
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

extension DateEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

        


