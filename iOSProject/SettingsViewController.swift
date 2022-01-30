//
//  SettingsViewController.swift
//  iOSProject
//
//  Created by Bennet Weingartz on 28.01.22.
//

import UIKit

var col = UIColor.systemBlue

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
        }
    }
}
