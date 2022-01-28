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
        switch(choice){
            case "Default": col = UIColor.systemBlue
            case "Mint": col = UIColor(red: 52.0/255, green: 238.0/255, blue: 219.0/255, alpha: 1)
            case "Scarlet": col = UIColor.systemRed
            case "Plum": col = UIColor(red: 160.0/255, green: 102.0/255, blue: 227.0/255, alpha: 1)
            default: ()
        }
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
