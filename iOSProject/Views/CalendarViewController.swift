//
//  CalendarViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 24.01.22.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var calendars: [Calendar]?
    
    override func viewDidLoad() {
        tableView.delegate = self
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension CalendarViewController: UITableViewDelegate {
    
}
