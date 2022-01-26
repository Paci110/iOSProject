//
//  WeekViewController.swift
//  iOSProject
//
//  Created by Pascal Köhler on 23.01.22.
//

import UIKit

class WeekViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var title1: UIButton!
    @IBOutlet weak var title2: UIButton!
    @IBOutlet weak var title3: UIButton!
    var titles: [UIButton] {
        [title1, title2, title3]
    }
    var tables: [UITableView] {
        [tableView1, tableView2, tableView3]
    }
    
    var dateEvents: [[DateEvent]]?
    var days: [Date] = []
    var currentDate: Int = 0
    
    func setDays(dateInWeek date: Date) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render(size: CGSize(width: view.frame.width, height: view.frame.height))
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        if days.count == 0 {
            setDays(dateInWeek: Date())
        }
        
        fetch()
    }
    
    func fetch() {
        for (index, title) in titles.enumerated() {
            let pos = index + currentDate
            title.setTitle(getDate(FromDate: days[pos], Format: "EE, DD.MM"), for: .normal) 
        }
        dateEvents = getWeek(date: days[0], filterFor: nil)
        for table in tables {
            table.reloadData()
        }
    }
    
    func render(size: CGSize) {
        for cell in collectionView.visibleCells {
            cell.prepareForReuse()
        }
        let cellWidth = size.width / 7
        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellLayout.itemSize.height)
    }
    
    func getTableIndex(_ tableView: UITableView) -> Int {
        for (index, table) in tables.enumerated() {
            if table == tableView {
                return index
            }
        }
        return 0
    }
    
    @IBAction func headerButtonClicked(_ sender: UIButton) {
        let button = getButtonIndex(sender)
        let date = days[button+currentDate]
        performSegue(withIdentifier: "dayView", sender: date)
    }
    
    func getButtonIndex(_ buttonElement: UIButton) -> Int {
        for (index, button) in titles.enumerated() {
            if buttonElement == button {
                return index
            }
        }
        return 0
    }
    
    @objc func respondToSwipe(gesture: UIGestureRecognizer)
    {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {return}
        
        switch swipeGesture.direction {
        case .left:
            //Jump to the previous day
            currentDate = min(currentDate + 3, 4)
            fetch()
        case .right:
            //Jump to the next day
            currentDate = max(currentDate - 3, 0)
            fetch()
        default:
            break
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        render(size: size)
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let (table, indexPath) = sender as? (UITableView, IndexPath) {
            let tableIndex = getTableIndex(table)
            let date = dateEvents![tableIndex + currentDate][indexPath.row]
            if let dest = segue.destination as? DateViewController {
                dest.testDate = date
                return
            }
        }
        if let dest = segue.destination as? DayViewController,
            let sender = sender as? Date{
            dest.date = sender
            return
        }
    }
}


extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDate = indexPath.row
        if currentDate > 4 {
            currentDate = 4
        }
        fetch()
    }
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        for (index, selectedTable) in tables.enumerated() {
            if tableView == selectedTable {
                let event = dateEvents![index+currentDate][indexPath.row]
                cell.textLabel?.text = event.title
                cell.detailTextLabel?.text = getDate(FromDate: event.start, Format: "HH:mm")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for (index, selectedTable) in tables.enumerated() {
            if tableView == selectedTable {
                return dateEvents![index+currentDate].count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "dateView", sender: (tableView, indexPath))
    }
}
