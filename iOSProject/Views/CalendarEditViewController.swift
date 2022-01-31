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
        calendar?.title = nameTextField.text ?? calendar!.title
        calendar?.color = picker?.selectedColor ?? calendar!.color
        calendarView?.reloadData()
    }
}
