//
//  FeatureController.swift
//  iOSProject
//
//  Created by Tony-Trung Luu Zelinski on 28.01.22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themes: UIPickerView!
    @IBOutlet weak var weekNumbersSwitch: UISwitch!
    
    weak var prevController: UIViewController?
    
    let themesArray = ["-----","Default","Mint","Scarlet","Plum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.tintColor = col
        
        self.themes.delegate = self
        self.themes.dataSource = self
        
        weekNumbersSwitch.isOn = fetchSettings().showWeekNumbers
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        prevController?.viewDidLoad()
    }
    
    @IBAction func weekNumbersSwitchChanged(_ sender: UISwitch) {
        let settings = fetchSettings()
        settings.showWeekNumbers = sender.isOn
        saveData() {
            let alarm = UIAlertController(title: "Could not save settings", message: "", preferredStyle: .alert)
            alarm.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alarm, animated: true, completion: nil)
            }
        }
    }
}

extension SettingsViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return themesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choice = "\(themesArray[row])"
        applyTheme(theme: choice)
        UIView.appearance().tintColor = col
        view.window?.tintColor = col
    }
}

extension SettingsViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themesArray.count
    }
}
