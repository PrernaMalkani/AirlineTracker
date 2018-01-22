//
//  AirportCodeViewController.swift
//  AirlineTracker
//
//  Created by Prerna on 10/11/17.
//  Copyright © 2017 Prerna. All rights reserved.
//

import UIKit

protocol AirportCodeDelegate: class {
    
    func aiportCodeUpdated(newCode: String)
}

class AirportCodeViewController: UIViewController {
    
    @IBOutlet weak var airportCodeTextField: UITextField!
    
    weak var delegate: AirportCodeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlur()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }

    @IBAction func submitButtonPressed() {
        
        guard let newCode = airportCodeTextField.text, !newCode.isEmpty else {
            return
        }
        
        delegate?.aiportCodeUpdated(newCode: newCode)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
