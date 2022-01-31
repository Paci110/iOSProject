//
//  YearViewController.swift
//  CalendarExampleTutorial
//
//  Created by Anastasiia Petrova on 17.01.22.
//

import UIKit

class YearViewController: UIViewController
{


    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //monthViewContr.didMove(toParent: self)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy"
        let dateStr = formatter.string(from: Date())
        yearLabel.text = dateStr
        
        // add Pinch
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(respondToPinch))
        //self.view.addGestureRecognizer(pinchGesture)
        
        configu()
    }
    
    
    func configu() {
        let widthOfCell: Float = (Float(view.frame.size.width)-90)/3
        let heightOfCell: Float = (Float(view.frame.size.height)-55)/5
        
        addMonthContr(heightOfCell: heightOfCell, widthOfCell: widthOfCell)
    }
    
    ///Adds the month controllers to the view
    func addMonthContr(heightOfCell: Float, widthOfCell: Float) {
        var count: Int = 0
        while count < 12 {
            let monthViewContr = MonthForYearViewController()
            var dateComp = DateComponents()
            
            dateComp.year = Int(yearLabel.text!)
            
            dateComp.month = count+1
            dateComp.day = 1
            let userCal = NSCalendar(identifier: .gregorian)!
            monthViewContr.selected = userCal.date(from: dateComp)!
            
            monthViewContr.viewDidLoad()
            addChild(monthViewContr)
            view.addSubview(monthViewContr.view)
            setMonthConstrains(monthViewContr: monthViewContr, count: count, heightOfCell: heightOfCell, widthOfCell: widthOfCell)
            
            monthViewContr.configureLabel(count: count)
            //need to do after constraints...
            monthViewContr.configureStackView(width: Int(widthOfCell), height: Int(heightOfCell*1/6))
                                                  
            monthViewContr.configureCollView(width: Int(widthOfCell), height: Int(heightOfCell*4/5))
//            monthViewContr.renderCells()
//            monthViewContr.renderMonth()
            
            count += 1
        }
        //addChild(monthViewContr)
        //view.addSubview(monthViewContr.view)
        //setMonthConstrains()
    }
    
    ///Sets the constraints of a MonthViewController
    func setMonthConstrains(monthViewContr : MonthForYearViewController, count : Int, heightOfCell: Float, widthOfCell: Float) {
        monthViewContr.view.translatesAutoresizingMaskIntoConstraints = false
        //can be 0,1,2,3
        let inRow: Int = Int(floor(Double(count)/3.0))
        //can be 0,1,2
        let inColumn: Int = count % 3
        monthViewContr.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25+40+CGFloat(Float(inRow)*(heightOfCell+5.0))).isActive = true

        monthViewContr.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20+CGFloat(Float(inColumn)*(widthOfCell+25.0))).isActive = true
//        monthViewContr.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        monthViewContr.view.heightAnchor.constraint(equalToConstant: CGFloat(heightOfCell)).isActive = true
        monthViewContr.view.widthAnchor.constraint(equalToConstant: CGFloat(widthOfCell)).isActive = true
    }
    
    @IBAction func nextYear(_ sender: Any) {
        yearLabel.text = String(Int(yearLabel.text!)!+1)
        
        configu()
    }
    
    @IBAction func prevYear(_ sender: Any) {
        yearLabel.text = String(Int(yearLabel.text!)!-1)
        configu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
        }
    }
}
