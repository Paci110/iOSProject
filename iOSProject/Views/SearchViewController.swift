//
//  SearchViewController.swift
//  iOSProject
//
//  Created by Kilian Sinke on 22.01.22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var allEvents: [DateEvent]?
    var filteredEvents: [DateEvent]?
    
    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
            self.allEvents = getData(entityName: "DateEvent") as? [DateEvent]
            self.filteredEvents = self.allEvents
            self.reloadData()
        }
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: Table view functions

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!
        let event = filteredEvents![indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = "\(getDate(FromDate: event.start, Format: dateFormat)) - \(getDate(FromDate: event.end, Format: dateFormat))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension SearchViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row at \(indexPath)")
        performSegue(withIdentifier: "dateView", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateView",
           let path = sender as? IndexPath,
           let dest = segue.destination as? DateViewController {
            dest.dateEvent = filteredEvents![path.row]
            
        }
    }
}

//MARK: SearchBar functions

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let allEvents = allEvents else { return }
        filteredEvents = searchText.isEmpty ? allEvents : allEvents.filter { (item: DateEvent) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased())
        }
        self.reloadData()
    }
    
    
}
