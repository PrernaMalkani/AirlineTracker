//
//  FlightStorage.swift
//  AirlineTracker
//
//  Created by Prerna on 10/13/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

//any class that implements this protocol gets the current flight storage class
protocol FlightStorageInjected { }
extension FlightStorageInjected {
    var flightStorageService: FlightStorage { get { return InjectionMap.flightStorage } }
}

//defines what a flight storage object needs to have
//facilitates the swapping in and out of different storage solutions
protocol FlightStorage {
    func update(flights: [Flight])
    func getFlights(completion: @escaping ([Flight])->Void)
}
