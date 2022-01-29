//
//  FeatureController.swift
//  iOSProject
//
//  Created by Tony-Trung Luu Zelinski on 28.01.22.
//

import UIKit

class FeatureController: UIViewController {

    @IBOutlet weak var themes : UIPickerView!
    
    let themesArray = ["-----","Default","Mint","Scarlet","Plum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.tintColor = col
        
        self.themes.delegate = self
        self.themes.dataSource = self
        
        
    }
}

extension FeatureController : UIPickerViewDelegate {
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

extension FeatureController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themesArray.count
    }
}
