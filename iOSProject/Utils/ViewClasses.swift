import Foundation
import UIKit
import MapKit

class BoolCell: UITableViewCell {
    @IBOutlet weak var lableObject: UILabel!
    @IBOutlet weak var switchObject: UISwitch!
}

class MapCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
}

class DateEventCell: UITableViewCell {
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    
    var dateEvent: DateEvent!
    
    //TODO: support events that are longer than a day and display dates in the view
    
    func addInfo(dateEvent: DateEvent) {
        //FIXME: should update cell if place is set in DateEvent
        guard contentStackView.subviews.count == 1 else {return}
        self.dateEvent = dateEvent
        let startString = getDate(FromDate: dateEvent.start, Format: "HH:mm")
        self.start.text = startString
        let endString = getDate(FromDate: dateEvent.end, Format: "HH:mm")
        self.end.text = endString
        
        let data = dateEvent.getData()
        for (index, info) in data.enumerated() {
            if index == 0 {
                self.title.text = (info as! String)
                continue
            }
            if let info = info as? String {
                self.contentStackView.addArrangedSubview(self.createLabel(text: info))
            }
            else if let info = info as? URL {
                self.contentStackView.addArrangedSubview(self.createLabel(text: info.absoluteString))
            }
            else if let info = info as? CLPlacemark {
                self.contentStackView.addArrangedSubview(self.createLabel(text: "\(info.name ?? "Address"), \(info.locality ?? "City"), \(info.country ?? "Country")" ))
            }
        }
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = text
        return label
    }
}
