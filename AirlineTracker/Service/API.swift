//
//  API.swift
//  AirlineTracker
//
//  Created by Prerna on 1/21/18.
//  Copyright © 2018 Prerna. All rights reserved.
//

import Foundation


struct API {
    
    static let authToken = "Basic YWFnZTQxNDAxMjgwODYyNDk3NWFiYWNhZjlhNjZjMDRlMWY6ODYyYTk0NTFhYjliNGY1M2EwZWJiOWI2ZWQ1ZjYwOGM="
    private static let baseURL = "https://api.qa.alaskaair.com/1/airports"
    
    struct Flights {
        static func from(airportCode: String) -> URL? {
            if airportCode.count != 3 { return nil }
            let fullURL = "\(baseURL)/\(airportCode)/flights/flightInfo?city=\(airportCode)&minutesBehind=0&minutesAhead=60"
            
            return URL(string: fullURL)
        }
    }
    
}
