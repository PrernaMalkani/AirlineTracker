//
//  FlightStorage.swift
//  AirlineTracker
//
//  Created by Prerna on 10/12/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import UIKit
import CoreData

fileprivate let flightEntity = "AirlineFlight"

fileprivate struct FlightKey {
    static let ID = "flightID"
    static let origin = "origin"
    static let destination = "destination"
    static let scheduledArrivalTime = "scheduledArrivalTime"
    static let estimatedArrivalTime = "estimatedArrivalTime"
}

final class CoreDataFlightStorage: FlightStorage {
    
    private var persistentContainer: NSPersistentContainer!
    
    init(){
        //TODO:  research a better way to do this - maybe by injecting a persistent container
        if !(Thread.isMainThread){
            //only do this if NOT on main thread (deadlock otherwise)
            DispatchQueue.main.sync {
                setup()
            }
        }else{
            setup()
        }
    }
    
    private func setup(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            fatalError("Cannot access App Delegate and the Core Data Stack")
        }
        self.persistentContainer = appDelegate.persistentContainer
    }
    
    //MARK: - Protocol
    //Replace any existing flight information, if any, with the given flights
    func update(flights: [Flight]) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            var context = self.persistentContainer.newBackgroundContext()
            self.deleteFlights(context: &context) //clear existing flights first
            self.insertFlights(context: &context, flights: flights) //insert new flights
            
            do {
                try context.save()
                print("Successfully stored new flights into Core Data")
            }
            catch{
                //could not save, so communicate error
                return
            }
        }
    }
    
    func getFlights(completion: @escaping ([Flight]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let context = self.persistentContainer.newBackgroundContext()
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: flightEntity)
            let sortDescriptors = [NSSortDescriptor(key: "estimatedArrivalTime", ascending: true)]
            fetchRequest.sortDescriptors = sortDescriptors
            
            var result: [Any]
            do { result = try context.fetch(fetchRequest) }
            catch{
                completion([])
                return
            }
            
            guard let managedObjects = result as? [NSManagedObject] else {
                completion([])
                return
            }
            
            var storedFlights: [Flight] = []
            for managedObject in managedObjects {
                
                if let fetchedFlight = self.createFlightFrom(managedObject: managedObject){
                    storedFlights.append(fetchedFlight)
                }
            }
            completion(storedFlights)
        }
    }
    
    //MARK: - Helper functions
    
    //MARK: Batch Updates
    private func deleteFlights(context: inout NSManagedObjectContext){
        
        var results: [Any]
        do { results = try context.fetch(NSFetchRequest(entityName: flightEntity)) }
        catch{
            //TODO: see if there is a valid recovery option
            print("Could not fetch existing flights for deletion")
            return
        }
        
        //delete all flights
        if let flights = results as? [NSManagedObject] {
            for flight in flights {
                context.delete(flight)
            }
        }
    }
    
    private func insertFlights(context: inout NSManagedObjectContext, flights: [Flight]){
        
        for flight in flights {
            if let entity = NSEntityDescription.entity(forEntityName: flightEntity, in: context) {
                var flightEntity = NSManagedObject(entity: entity,
                                                   insertInto: context)
                self.setValues(entity: &flightEntity, flight: flight)
            }
        }
    }

    //MARK: Entity Mapping
    private func createFlightFrom(managedObject: NSManagedObject) -> Flight? {
        
        guard let flightID = managedObject.value(forKey: FlightKey.ID) as? String,
            let origin = managedObject.value(forKey: FlightKey.origin) as? String,
            let destination = managedObject.value(forKey: FlightKey.destination) as? String,
            let scheduledArrivalTime = managedObject.value(forKey: FlightKey.scheduledArrivalTime) as? Date,
            let estimatedArrivalTime = managedObject.value(forKey: FlightKey.estimatedArrivalTime) as? Date else{
                return nil
        }
        return Flight(flightID: flightID,
                      origin: origin,
                      destination: destination,
                      scheduledArrivalTime: scheduledArrivalTime,
                      estimatedArrivalTime: estimatedArrivalTime)
    }
    
    private func setValues(entity: inout NSManagedObject, flight: Flight){
        
        entity.setValue(flight.flightID, forKey: FlightKey.ID)
        entity.setValue(flight.origin, forKey: FlightKey.origin)
        entity.setValue(flight.destination, forKey: FlightKey.destination)
        entity.setValue(flight.scheduledArrivalTime, forKey: FlightKey.scheduledArrivalTime)
        entity.setValue(flight.estimatedArrivalTime, forKey: FlightKey.estimatedArrivalTime)
    }

}
