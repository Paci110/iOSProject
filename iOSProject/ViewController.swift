//
//  ViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 16.12.21.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showDateView(_ sender: UIButton) {
        performSegue(withIdentifier: "dateView", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

