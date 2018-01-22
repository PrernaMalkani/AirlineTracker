//
//  ViewController.swift
//  AirlineTracker
//
//  Created by Prerna on 10/10/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import UIKit

class ArrivalsViewController: UIViewController {
    
    @IBOutlet weak var arrivalsTableview: UITableView!
    
    var viewModel: ArrivalsViewModel! //required component - okay to implicitly unwrap

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ArrivalsViewModel(delegate: self)
        if let airport = viewModel.airportCode {
            title = airport
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier else {
            return
        }
        
        if id == "AirportCodeSegue", let vc = segue.destination as? AirportCodeViewController {
            vc.delegate = self
        }
    }
    
    func presentError(title: String, message: String) {

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
}

extension ArrivalsViewController: ArrivalsViewModelDelegate {
    
    func flightsUpdated(newFlights: [Flight]) {
        DispatchQueue.main.async {
            self.arrivalsTableview.reloadData()
        }
    }
    
    func handleError(title: String, message: String){
        DispatchQueue.main.async {
            self.presentError(title: title, message: message)
        }
    }
    
    func askForAirportCode() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "AirportCodeSegue", sender: nil)
        }
    }
}

extension ArrivalsViewController: AirportCodeDelegate {
    
    func aiportCodeUpdated(newCode: String) {
        title = newCode
        viewModel.update(airportCode: newCode)
    }
}

extension ArrivalsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArrivalCell", for: indexPath)
        
        guard let arrivalCell = cell as? ArrivalTableViewCell else {
            fatalError("Misconfiguration")
        }
        
        arrivalCell.configureWith(flight: viewModel.flights[indexPath.row])
        return arrivalCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flights.count
    }
    
}

extension ArrivalsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}






