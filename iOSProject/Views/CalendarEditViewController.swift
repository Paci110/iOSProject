//
//  CalendarEditViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 24.01.22.
//

import Foundation
import UIKit

class CalendarEditViewController: UIViewController {
    /*
     textfield to give a name for the calender
     picker to choose a colour
     */
    @IBOutlet weak var nameTextField: UITextField!
    var picker: UIColorPickerViewController?
    var calendar: Calendar?
    
    var sender: UIViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let dest = segue.destination as? UIColorPickerViewController{
            picker = dest
        }
    }
    
    override func viewDidLoad() {
        nameTextField.text = calendar?.title
        picker?.selectedColor = calendar!.color
    }
    //save the given data if the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        calendar?.color = picker?.selectedColor ?? calendar!.color
        let cals = getCalendars().map { $0.title }
        var text:String = nameTextField.text ?? calendar!.title
        let former = text
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
        
        if text != former {
            let alert = UIAlertController(title: "Calendar Name was Taken", message: "\"\(former)\" has been changed to \"\(text)\"", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            sender!.present(alert, animated: true, completion: nil)
        }
        
        if let sender = sender as? CalendarViewController{
            sender.reloadData()
        } else if let sender = sender as? DateEditViewController{
            sender.reloadData()
        }
    }
}
