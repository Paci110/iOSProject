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
    
    func goBackAndPerformSegue(controllerIdentifier: String) {
        self.dismiss(animated: true) {
            guard let segueIdentifier = self.segueIdentifier else {
                return
            }
            //self.previousController?.performSegue(withIdentifier: segueIdentifier, sender: nil)
            
            var foundController: Bool = false
            
            if let nav = self.previousController?.navigationController {
                for (index, controller) in nav.viewControllers.enumerated() {
                    if controller.restorationIdentifier == controllerIdentifier {
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
                /*
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyBoard.instantiateViewController(withIdentifier: segueIdentifier)
                if let view = view as? SettingsViewController {
                    view.prevController = self.previousController
                }
                self.previousController?.navigationController?.pushViewController(view, animated: false)
                 */
                self.previousController?.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    }
    
    @IBAction func clickDayButton(_ sender: UIButton) {
        guard previousController?.restorationIdentifier != "dayView" else {
            return
        }
        segueIdentifier = "ToDayView"
        goBackAndPerformSegue(controllerIdentifier: "dayView")
    }
    
    @IBAction func clickWeekButton(_ sender: UIButton) {
        guard !(previousController is WeekViewController) else {
            return
        }
        segueIdentifier = "ToWeekView"
        goBackAndPerformSegue(controllerIdentifier: "weekView")
    }
    
    @IBAction func clickMonthButton(_ sender: Any) {
        guard previousController?.restorationIdentifier != "monthView" else {
            return
        }
        segueIdentifier = "ToMonthView"
        goBackAndPerformSegue(controllerIdentifier: "monthView")
    }
    
    @IBAction func clickYearButton(_ sender: Any) {
        guard previousController?.restorationIdentifier != "yearView" else {
            return
        }
        segueIdentifier = "ToYearView"
        goBackAndPerformSegue(controllerIdentifier: "yearView")
    }
    
    @IBAction func clickCalendersButton(_ sender: Any) {
        guard previousController?.restorationIdentifier != "calendarsView" else {
            return
        }
        segueIdentifier = "ToCalendarView"
        goBackAndPerformSegue(controllerIdentifier: "calendarsView")
    }
    
    @IBAction func clickSettingsButton(_ sender: Any) {
        guard previousController?.restorationIdentifier != "settingsView" else {
            return
        }
        segueIdentifier = "ToSettingsView"
        goBackAndPerformSegue(controllerIdentifier: "settingsView")
    }
    @IBAction func clickNavigationButton(_ sender: UIButton) {
        guard previousController?.restorationIdentifier != "searchView" else {
            return
        }
        segueIdentifier = "ToSearchView"
        goBackAndPerformSegue(controllerIdentifier: "searchView")
    }
}
