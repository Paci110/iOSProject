import UIKit

class WeekViewController: UITableViewController {
    
    var dateEvents: [[DateEvent]]?
    var date: Date = Date()
    var headerSet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = NSCalendar.current
        let week = calendar.dateComponents([.weekOfYear, .year], from: date)
        dateEvents = getWeek(cw: week.weekOfYear!, year: week.year!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (dateEvents?.count ?? 0) + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if headerSet == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! HeaderWeekCell
            let title = WeekDay.init(rawValue: indexPath.row)?.description
            cell.title.text = title
            headerSet = true
            return cell
        //}
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "event", for: indexPath) as! EventWeekCell
        //cell.title.text = dateEvents?[indexPath.row][0].title
        dateEvents?[indexPath.section-1].remove(at: 0)
        return cell
         */
    }
}
