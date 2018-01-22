//
//  MockPersistence.swift
//  AirlineTrackerTests
//
//  Created by Prerna on 10/13/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import XCTest
import Foundation
@testable import AirlineTracker

class MockCoreDataFlightStorage_Empty: FlightStorage {
    
    func update(flights: [Flight]) {
        
    }
    
    func getFlights(completion: @escaping ([Flight]) -> Void) {
        completion([])
    }
}

class MockCoreDataFlightStorage_Full: FlightStorage {
    
    func update(flights: [Flight]) {
        
    }
    
    func getFlights(completion: @escaping ([Flight]) -> Void) {
        
        let flightA = Flight(flightID: "1234", origin: "SEA", destination: "LAX",
                             scheduledArrivalTime: Date(), estimatedArrivalTime: Date())
        let flightB = Flight(flightID: "7777", origin: "JFK", destination: "MIA",
                             scheduledArrivalTime: Date(), estimatedArrivalTime: Date())
        let flightC = Flight(flightID: "3333", origin: "ATL", destination: "BOS",
                             scheduledArrivalTime: Date(), estimatedArrivalTime: Date())
        
        completion([flightA, flightB, flightC])
    }
    
}
