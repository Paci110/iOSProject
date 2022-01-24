//
//  WeekViewController2.swift
//  iOSProject
//
//  Created by Pascal Köhler on 23.01.22.
//

import UIKit

class WeekViewController2: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    var titles: [UILabel] {
        return [title1, title2, title3]
    }
    
    var dateEvents: [[DateEvent]]?
    var days: [Date] = []
    //TODO: currentDate have to be less then 4
    var currentDate: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render(size: CGSize(width: view.frame.width, height: view.frame.height))
        //TODO implement fetch
        var calendar = NSCalendar.current
        calendar.locale = Locale(identifier: "en")
        calendar.firstWeekday = 2
        if let interv = calendar.dateInterval(of: .weekOfYear, for: Date()) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: interv.start) {
                    days.append(day)
                }
            }
        }
        let dates = calendar.dateComponents([.weekOfYear, .year], from: Date())
        dateEvents = getWeek(cw: dates.weekOfYear!, year: dates.year!)
        fetch()
    }
    
    func fetch() {
        for (index, title) in titles.enumerated() {
            let pos = index + currentDate
            title.text = getDate(FromDate: days[pos], Format: "EE, DD.MM")
        }
    }
    
    func render(size: CGSize) {
        //TODO: How to fit the size if device is rotating
        for cell in collectionView.visibleCells {
            cell.prepareForReuse()
        }
        let cellWidth = view.frame.width / 7
        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellLayout.itemSize.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        render(size: size)
        viewDidLoad()
    }
}


extension WeekViewController2: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeaderWeekCell
        var calendar = NSCalendar.current
        calendar.locale = Locale(identifier: "en")
        let weekday = calendar.shortWeekdaySymbols[(indexPath.row+1) % 7]
        cell.title.text = weekday
        cell.title.textAlignment = .center
        return cell
    }
}

extension WeekViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1
        switch tableView {
        case tableView1:
            print("Works")
        default:
            print("Default")
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}