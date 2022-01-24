//
//  DateCell.swift
//  CalendarApplication
//
//  Created by Anastasiia Petrova on 19.01.22.
//

import Foundation
import UIKit

class DateCell: UICollectionViewCell
{
    var dayOfM = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayOfM.text = "No"
        dayOfM.font = dayOfM.font.withSize(7)
        addSubview(dayOfM)
        
        dayOfM.translatesAutoresizingMaskIntoConstraints = false
        dayOfM.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dayOfM.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

