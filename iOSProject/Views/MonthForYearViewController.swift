//
//  MonthViewController.swift
//  CalendarApplication
//
//  Created by Anastasiia Petrova on 18.01.22.
//

import Foundation
import UIKit

class MonthForYearViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    //var collView = UICollectionView()
    
    var collView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:  UICollectionViewLayout.init())
    
    
    //var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    //squares to render the screen
    var squares = [String]()
    //our selected date
    var selected = Date()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        squares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        cell.dayOfM.text = squares[indexPath.item]
        //cell.backgroundColor = UIColor.blue
        return cell
    }
    
    
    var stackView = UIStackView()
    
    var monthLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureLabel(count: Int) {
        
        monthLabel.text = CHelp().calendar.shortMonthSymbols[count]
        monthLabel.textColor = col
        
        monthLabel.font = monthLabel.font.withSize(10)
        view.addSubview(monthLabel)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true

        
    }
    
    func configureStackView(width: Int, height: Int) {
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        //stackView.spacing = 20
        
        addLabelsToStackView()
        setStackViewConstraints(width: width, height: height)
    }
    
    func addLabelsToStackView() {
        for day in ["M", "D", "M", "D", "F", "S", "S"] {
            let labelDay = UILabel()
            labelDay.text = day
            labelDay.font = labelDay.font.withSize(9)
            
            stackView.addArrangedSubview(labelDay)
        }
        
    }
    
    func setStackViewConstraints(width: Int, height: Int) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(height/3)).isActive = true

        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    func configureCollView(width: Int, height: Int) {
        collView = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height)), collectionViewLayout: UICollectionViewFlowLayout.init())
        
        collView.delegate = self
        collView.dataSource = self
        collView.register(DateCell.self, forCellWithReuseIdentifier: "dateCell")
        //collView.backgroundColor = .blue
        
        view.addSubview(collView)
        setCollectionViewConstraints(height: height)
        
        renderCells(width: width, height: height)
        renderMonth()
    }
    
    
    
    func renderCells(width: Int, height: Int) {
        //devide 8 because of paddings
        let widthOfCell = Double(width-5) / 18
        let heightOfCell = Double(height) / 12
        
        //type casting and size setting
        let cellsLayout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        cellsLayout.itemSize = CGSize(width: widthOfCell, height: heightOfCell)
        cellsLayout.sectionInset.left = 1
        cellsLayout.sectionInset.right = 1
    }
    
    
    func renderMonth()
    {
        squares.removeAll()
        
        let daysInMonth = CHelp().howManyDaysInMonth(date: selected)
        let firstDayOfMonth = CHelp().selectFirst(date: selected)
        let x = CHelp().whichWeekday(date: firstDayOfMonth) - 1
        let startingSpaces = x < 0 ? 6 : x //If Sunday (-1) use 6 free spaces
        
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
        
        
        collView.reloadData()
        
    }
    
    func setCollectionViewConstraints(height: Int) {
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(height/4)).isActive = true

        collView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
}
