//
//  NavigationMenuController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 30.01.22.
//

import UIKit

class NavigationMenuController: UIViewController {
    
    var segueIdentifier: String?
    var previousController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .pageSheet
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
        }
    }
    
    func goBackAndPerformSegue(controllerClass: AnyClass) {
        self.dismiss(animated: true) {
            guard let segueIdentifier = self.segueIdentifier else {
                return
            }
            //self.previousController?.performSegue(withIdentifier: segueIdentifier, sender: nil)
            
            var foundController: Bool = false
            
            if let nav = self.previousController?.navigationController {
                for (index, controller) in nav.viewControllers.enumerated() {
                    if controller.restorationIdentifier == segueIdentifier {
                        foundController = true
                        let count = nav.viewControllers.count
                        guard count != index + 1 else {
                            break
                        }
                        for _ in 1...(count - index - 1) {
                            nav.popViewController(animated: false)
                        }
                    }
                }
            }
            
            if !foundController {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyBoard.instantiateViewController(withIdentifier: segueIdentifier)
                self.previousController?.navigationController?.pushViewController(view, animated: false)
            }
        }
    }
    
    @IBAction func clickDayButton(_ sender: UIButton) {
        segueIdentifier = "dayView"
        goBackAndPerformSegue(controllerClass: DayViewController.self)
    }
    
    @IBAction func clickWeekButton(_ sender: UIButton) {
        segueIdentifier = "weekView"
        goBackAndPerformSegue(controllerClass: WeekViewController.self)
    }
    
    @IBAction func clickMonthButton(_ sender: Any) {
        segueIdentifier = "monthView"
        goBackAndPerformSegue(controllerClass: MonthViewController.self)
    }
    
    @IBAction func clickYearButton(_ sender: Any) {
        segueIdentifier = "yearView"
        goBackAndPerformSegue(controllerClass: YearViewController.self)
    }
    
    @IBAction func clickCalendersButton(_ sender: Any) {
        segueIdentifier = "calendarsView"
        goBackAndPerformSegue(controllerClass: CalendarViewController.self)
    }
    
    @IBAction func clickSettingsButton(_ sender: Any) {
        segueIdentifier = "settingsView"
        goBackAndPerformSegue(controllerClass: SettingsViewController.self)
    }
}
