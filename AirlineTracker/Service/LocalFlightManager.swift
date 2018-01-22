//
//  LocalFlightManager.swift
//  AirlineTracker
//
//  Created by Prerna on 10/10/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

fileprivate let airportCodeKey = "airportCode"
fileprivate let flightsKey = "flights"
fileprivate let lastUpdatedKey = "lastUpdated"

fileprivate let expirationTime: TimeInterval = 60 //the maximum amount of time to keep flight information

protocol LocalFlightManagerDelegate: class {
    
    func flightsUpdated(newFlights: [Flight])
    func errorReceived() // TODO: error
}

final class LocalFlightManager: FlightStorageInjected, RemoteStorageInjected {
    
    static let shared = LocalFlightManager()
    weak var delegate: LocalFlightManagerDelegate?
    private var timer: Timer?
    
    private(set) var flights: [Flight] {
        didSet {
            delegate?.flightsUpdated(newFlights: flights)
            flightStorageService.update(flights: flights)
        }
    }
    private(set) var currentAirport: String? {
        didSet {
            UserDefaults.standard.set(currentAirport, forKey: airportCodeKey)
        }
    }
    private(set) var lastUpdated: Date {
        didSet {
            UserDefaults.standard.set(lastUpdated, forKey: lastUpdatedKey)
        }
    }
    
    private init() {
        
        //initialized with basic persisted data, then fetch flights
        self.lastUpdated = (UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date) ??  Date(timeIntervalSince1970: 0)
        self.currentAirport = (UserDefaults.standard.object(forKey: airportCodeKey) as? String)
        self.flights = []

        setup()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setup(){
        if abs(lastUpdated.timeIntervalSinceNow) > expirationTime {
            //we are re-launching the app with expired or non-existant data - fetch new data
            updateFlights()
            return
        }
        
        //try to get persisted flights - if that fails, ask the server
        flightStorageService.getFlights(){ [unowned self] storedFlights in
            if storedFlights.isEmpty {
                self.updateFlights()
            }else {
                self.flights = storedFlights
                let newExpiration = max(expirationTime - abs(self.lastUpdated.timeIntervalSinceNow), 0) //in case exp time has elapsed since setup
                self.timer = Timer.scheduledTimer(timeInterval: newExpiration,
                                                   target: self, selector: #selector(self.updateFlights),
                                                   userInfo: nil, repeats: false)

            }
        }
    }
    
    func update(airportCode: String){
        
        //fetch new flight data
        currentAirport = airportCode
        updateFlights()
    }
    
    @objc func updateFlights(){
        print("Expiration reached - fetching new data!")
        
        guard let airportCode = currentAirport else { return }
        
        remoteStorageService.fetchFlights(airportCode: airportCode) { [unowned self] newFlights in
            self.flights = newFlights
            self.lastUpdated = Date()
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(
                    timeInterval: expirationTime, target: self,
                    selector: #selector(self.updateFlights), userInfo: nil, repeats: false)
            }
        }
    }
}


