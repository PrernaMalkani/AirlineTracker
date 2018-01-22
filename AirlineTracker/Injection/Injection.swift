//
//  Injection.swift
//  AirlineTracker
//
//  Created by Prerna on 10/13/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

struct InjectionMap {
    
    static var flightStorage: FlightStorage = CoreDataFlightStorage()
    static var remoteStorage: RemoteStorage = MockFlightService()
}
