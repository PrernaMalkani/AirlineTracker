//
//  ArrivalsViewModel.swift
//  AirlineTracker
//
//  Created by Prerna on 10/10/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

protocol ArrivalsViewModelDelegate: class {
    
    func flightsUpdated(newFlights: [Flight])
    func handleError(title: String, message: String)
    func askForAirportCode()
}

final class ArrivalsViewModel {
    
    var airportCode: String?
    var flights: [Flight] = [] {
        didSet {
            delegate?.flightsUpdated(newFlights: flights)
        }
    }
    weak var delegate: ArrivalsViewModelDelegate?
    
    convenience init() {
        self.init(delegate: nil)
    }
    
    init(delegate: ArrivalsViewModelDelegate?){
        
        self.delegate = delegate
        LocalFlightManager.shared.delegate = self
        airportCode = LocalFlightManager.shared.currentAirport
        if airportCode == nil {
            delegate?.askForAirportCode()
        }else{
            flights = LocalFlightManager.shared.flights
        }
    }
    
    func update(airportCode: String){
        self.airportCode = airportCode
        LocalFlightManager.shared.update(airportCode: airportCode)
    }
}

extension ArrivalsViewModel: LocalFlightManagerDelegate {
    
    func flightsUpdated(newFlights: [Flight]) {
        //sorting is the responsibility of the view model...
        flights = newFlights.sorted(by: { $0.estimatedArrivalTime < $1.estimatedArrivalTime })
        
        if flights.count == 0 {
            delegate?.handleError(title: "No Data",
                                  message: "There seem to be no incoming flights for this airport")
        }
    }
    
    func errorReceived(){
        //TODO: fill in
    }
    
}
