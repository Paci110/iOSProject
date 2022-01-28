//
//  FeatureController.swift
//  iOSProject
//
//  Created by Tony-Trung Luu Zelinski on 28.01.22.
//

import UIKit

class FeatureController: UIViewController {

    @IBOutlet weak var themes : UIPickerView!
    
    //edit this!!
    let something = ["1","2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.themes.delegate = self
        self.themes.dataSource = self
        
        
        
       
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeatureController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return something[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let choose = "\(something[row])"
        print (choose)
    }
}

extension FeatureController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return something.count
    }
}
