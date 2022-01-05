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
