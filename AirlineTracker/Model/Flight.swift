//
//  Flight.swift
//  AirlineTracker
//
//  Created by Prerna on 10/10/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

fileprivate struct FlightDate {
    
    //date formatters are expensive, so keep this around
    static var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
}

struct Flight {
    
    let flightID: String
    let origin: String
    let destination: String
    let scheduledArrivalTime: Date
    let estimatedArrivalTime: Date
    
    init(flightID: String,
         origin: String,
         destination: String,
         scheduledArrivalTime: Date,
         estimatedArrivalTime: Date){
        
        self.flightID = flightID
        self.origin = origin
        self.destination = destination
        self.scheduledArrivalTime = scheduledArrivalTime
        self.estimatedArrivalTime = estimatedArrivalTime
    }
    
    init(json: JSONFlight) {
        
        let schTime = FlightDate.formatter.date(from: json.SchedArrTime)
        let estTime = FlightDate.formatter.date(from: json.EstArrTime)
        self.init(flightID: json.FltId,
                  origin: json.Orig,
                  destination: json.Dest,
                  scheduledArrivalTime: schTime ?? Date(),
                  estimatedArrivalTime: estTime ?? Date())
    }
}


struct JSONFlight: Decodable {
    
    let FltId: String
    let Orig: String
    let Dest: String
    let SchedArrTime: String
    let EstArrTime: String
}
