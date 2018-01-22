//
//  MockFlightService.swift
//  AirlineTracker
//
//  Created by Prerna on 1/21/18.
//  Copyright © 2018 Prerna. All rights reserved.
//

import Foundation

struct TimeConverter {
    static func minutesFrom(hour: Int) -> Int {
        return hour * 60
    }
}

final class MockFlightService: RemoteStorage {
    
    func fetchFlights(airportCode: String, completion: @escaping ([Flight]) -> Void) {
        
        var flights: [Flight] = []
        for _ in 0..<20 {
            let airport = randomDestinations()
            flights.append(createFlight(origin: airport.0, destination: airport.1))
        }
        completion(flights)
    }
    
    private func createFlight(origin: String, destination: String) -> Flight {
        let scheduledTime = randomDate()
        return Flight(
            flightID: randomId(),
            origin: origin,
            destination: destination,
            scheduledArrivalTime: scheduledTime,
            estimatedArrivalTime: randomDate(date: scheduledTime))
    }
    
    //MARK: - Random Generation
    private func randomId() -> String {
        var id = ""
        for _ in 0..<5 {
            id += String(arc4random_uniform(9))
        }
        return id
    }
    
    private func randomDate(date: Date = Date()) -> (Date) {
        return calendar.date(byAdding: .minute, value: randomMinutes(), to: date) ?? date
    }
    
    private func randomMinutes() -> Int {
        return TimeConverter.minutesFrom(hour: 1) + Int(arc4random_uniform(UInt32(TimeConverter.minutesFrom(hour: 24))))
    }

    private func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(airports.count-1)))
    }

    private func randomDestinations() -> (String, String) {
        let origin = randomIndex()
        var destination: Int
        
        repeat {
            destination = randomIndex()
        } while origin == destination
        
        return (airports[origin], airports[destination])
    }
    
    private var calendar: Calendar {
        return Calendar.current
    }
}

fileprivate var airports: [String] = [
    "ATL", "MIA", "LAS", "JFK", "BOM", "CDG", "AMS", "SFO", "FRA", "DEN", "SLC", "MAD",
    "ORD", "DTW", "BWI", "ITO", "HNL", "MLE", "BOS", "CUN", "YTZ", "YVR", "YHU","LCY"]





