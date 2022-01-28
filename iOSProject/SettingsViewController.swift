//
//  SettingsViewController.swift
//  iOSProject
//
//  Created by Bennet Weingartz on 28.01.22.
//

import UIKit

class SettingsViewController: UIViewController {
    let col = UIColor(red: 152.0/255, green: 238.0/255, blue: 218.0/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func colorUpdate(_ sender: UIButton) {
        UIView.appearance().tintColor = col
        view.window?.tintColor = col
        navigationController?.popViewController(animated: true)
    }
}
