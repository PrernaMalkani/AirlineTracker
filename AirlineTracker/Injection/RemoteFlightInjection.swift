//
//  RemoteFlightInjection.swift
//  AirlineTracker
//
//  Created by Prerna on 1/21/18.
//  Copyright © 2018 Prerna. All rights reserved.
//

import Foundation

//any class that implements this protocol gets the current flight storage class
protocol RemoteStorageInjected { }
extension RemoteStorageInjected {
    var remoteStorageService: RemoteStorage { return InjectionMap.remoteStorage }
}

//defines what a flight storage object needs to have
//facilitates the swapping in and out of different storage solutions
protocol RemoteStorage {
    func fetchFlights(airportCode: String, completion: @escaping ([Flight])->Void)
}
