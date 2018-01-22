//
//  ArrivalTableViewCell.swift
//  AirlineTracker
//
//  Created by Prerna on 10/11/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import UIKit

fileprivate struct CellFlightDate {
    //date formatters are expensive, so keep this around
    //only show hour and minute
    static var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mma"
        return dateFormatter
    }
}

class ArrivalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var scheduledTimeLabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    
    static let identifier = "ArrivalCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWith(flight: Flight){
     
        originLabel.text = flight.origin
        destinationLabel.text = flight.destination
        flightNumberLabel.text = flight.flightID
        
        let schTime = CellFlightDate.formatter.string(from: flight.scheduledArrivalTime)
        let estTime = CellFlightDate.formatter.string(from: flight.estimatedArrivalTime)
        
        scheduledTimeLabel.text = schTime
        estimatedTimeLabel.text = estTime
    }
    
    
}
