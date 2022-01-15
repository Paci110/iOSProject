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
    
    //TODO: support events that are longer than a day and display dates in the view
    
    func addInfo(dateEvent: DateEvent) {
        /*
        for subview in self.contentStackView.arrangedSubviews {
            if subview == self.title {
                continue
            }
            self.contentStackView.removeArrangedSubview(subview)
        }
         */
        guard contentStackView.subviews.count == 1 else {return}
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
        }
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = text
        return label
    }
}
