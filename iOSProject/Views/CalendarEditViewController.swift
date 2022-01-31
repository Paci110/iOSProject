//
//  CalendarEditViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 24.01.22.
//

import Foundation
import UIKit

class CalendarEditViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    var picker: UIColorPickerViewController?
    var calendar: Calendar?
    
    var calendarView: CalendarViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UIColorPickerViewController{
            picker = dest
        }
    }
    
    override func viewDidLoad() {
        nameTextField.text = calendar?.title
        picker?.selectedColor = calendar!.color
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let cals = getCalendars().map { $0.title }
        var text:String = nameTextField.text ?? calendar!.title
        var i = 0 //counter
        while(true){
            if(cals.contains(text)){
                text = nameTextField.text ?? calendar!.title
                text = "\(text)(\(i))"
            } else {
                break
            }
            i += 1
        }
        calendar?.title = text
        calendar?.color = picker?.selectedColor ?? calendar!.color
        calendarView?.reloadData()
    }
}
