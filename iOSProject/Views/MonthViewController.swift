//
//  WeekController.swift
//  iOSProject
//
//  Created by Anastasiia Petrova on 22.01.22.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    
    //squares to render the screen
    var squares = [String]()
    //our selected date
    var selected = Date()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // add Pinch
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(respondToPinch))
        self.view.addGestureRecognizer(pinchGesture)
        
        
        return squares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CCell
        
        cell.dayOfMonth.text = squares[indexPath.item]
        
        return cell
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        renderCells()
        renderMonth()      
        
        
        
    }
    
    func renderCells()
    {
        //devide 8 because of paddings
        let widthOfCell = ((collView).frame.size.width) / 8
        let heightOfCell = (collView.frame.size.height) / 8
        
        //type casting and size setting
        let cellsLayout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        cellsLayout.itemSize = CGSize(width: widthOfCell, height: heightOfCell)
    }
    
    func renderMonth()
    {
        squares.removeAll()
        
        let daysInMonth = CHelp().howManyDaysInMonth(date: selected)
        let firstDayOfMonth = CHelp().selectFirst(date: selected)
        let startingSpaces = CHelp().whichWeekday(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                squares.append("")
            }
            else
            {
                squares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        if label != nil {
            label.text = CHelp().toStringMonth(date: selected) + " " + CHelp().toStringYear(date: selected)
        }
        collView.reloadData()
    }
    
    @IBAction func previousMonth(_ sender: Any)
    {
        selected = CHelp().removeMonth(date: selected)
        renderMonth()
    }
    
    @IBAction func nextMonth(_ sender: Any)
    {
        selected = CHelp().addMonth(date: selected)
        renderMonth()
    }
    

    
    
    
    
    
    @objc func respondToPinch(gesture: UIGestureRecognizer){
        guard let pinchGesture = gesture as? UIPinchGestureRecognizer else {return}
        //view.backgroundColor = .green
        //scale can be changed here
        if (pinchGesture.scale <= CGFloat(1)) {
            //view.backgroundColor = .black
            
            //get controller from StoryBoard
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AnotherController = storyBoard.instantiateViewController(withIdentifier: "dayView") as! DayViewController
            self.navigationController?.pushViewController(AnotherController, animated: false)
            
            return
        }else {
            
            //change to year view
            //get controller from StoryBoard
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AnotherController = storyBoard.instantiateViewController(withIdentifier: "yearView") as! YearViewController
            self.navigationController?.pushViewController(AnotherController, animated: false)
            return
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NavigationMenuController {
            dest.previousController = self
        }
    }
    
    
    
    
}

