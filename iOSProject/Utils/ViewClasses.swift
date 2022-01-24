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
    @IBOutlet weak var calendarColorView: UIView!
    
    var dateEvent: DateEvent!
    
    //TODO: support events that are longer than a day and display dates in the view
    
    func addInfo(dateEvent: DateEvent) {
        //FIXME: should update cell if place is set in DateEvent
        self.dateEvent = dateEvent
        let startString = getDate(FromDate: dateEvent.start, Format: "HH:mm")
        self.start.text = startString
        let endString = getDate(FromDate: dateEvent.end, Format: "HH:mm")
        self.end.text = endString
        
        calendarColorView.backgroundColor = dateEvent.calendar.color
        
        let data = dateEvent.getData()
        for (index, info) in data.enumerated() {
            if index == 0 {
                self.title.text = (info as! String)
                continue
            }
            
            switch info {
                case let info as String:
                self.contentStackView.addArrangedSubview(self.createLabel(text: info))
            case let info as EventSeries:                self.contentStackView.addArrangedSubview(self.createLabel(text: "Repeating every \(info.value) \(info.timeInterval)"))
            case let info as Date:
                var dateBetween = dateEvent.start.distance(to: info)
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute]
                formatter.unitsStyle = .abbreviated
                let additionStr = dateBetween < 0 ? "before" : "after"
                if dateBetween < 0 {
                    dateBetween.negate()
                }
                var str = formatter.string(from: dateBetween)
                if str == nil {
                    str = "0min"
                }
                self.contentStackView.addArrangedSubview(self.createLabel(text: "Reminder: \(str!) \(additionStr)"))
            case let info as URL:
                self.contentStackView.addArrangedSubview(self.createLabel(text: info.absoluteString))
            case let info as CLPlacemark:
                self.contentStackView.addArrangedSubview(self.createLabel(text: "\(info.name ?? "Address"), \(info.locality ?? "City"), \(info.country ?? "Country")" ))
            default:
                continue
            }
            //TODO: use line seperators?
            /*
            if index != data.count {
                let view = UIView()
                view.backgroundColor = .systemGray4
                let constr = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 1)
                constr.priority = UILayoutPriority(999)
                view.addConstraint(constr)
                self.contentStackView.addArrangedSubview(view)
            }
             */
        }
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = text
        return label
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for (index, subview) in contentStackView.arrangedSubviews.enumerated() {
            guard index != 0 else {continue}
            subview.removeFromSuperview()
        }
    }
}

class HeaderWeekCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
}

class EventWeekCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
}

class WeekCollectionLayout: UICollectionViewLayout {
    
}
