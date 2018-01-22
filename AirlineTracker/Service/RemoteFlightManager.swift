//
//  RemoteFlightManager.swift
//  AirlineTracker
//
//  Created by Prerna on 10/10/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import Foundation

final class RemoteFlightManager: RemoteStorage {
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default //always fetch the newest data
        config.httpAdditionalHeaders =  ["Authorization" : API.authToken, "Cache-Control" : "public, s-maxage=600"]
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }
    
    func fetchFlights(airportCode: String, completion: @escaping ([Flight])->Void){
        
        guard let url = API.Flights.from(airportCode: airportCode) else {
            completion([])
            return
        }
        
        session.dataTask(with: url){ data, response, error in
            
            if let e = error {
                print(e.localizedDescription)
                completion([])
                return
            }
            guard let responseData = data else {
                completion([])
                return
            }
            
            do {
                let flights = try JSONDecoder().decode([JSONFlight].self, from: responseData).map({Flight(json: $0 )})
                completion(flights)
            } catch {
                completion([])
            }
            
        }.resume()
    }
}
