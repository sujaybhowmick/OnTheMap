//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 7/4/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var address: UITextView!
    
    var placeMark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.address.delegate = self
        self.setUpButton()
    }
    
    private func setUpButton(){
        findOnTheMapButton.layer.cornerRadius = 5
        findOnTheMapButton.layer.borderWidth = 0
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        let clGeoEncoder = CLGeocoder()
        self.activityIndicator.startAnimating()
        clGeoEncoder.geocodeAddressString(address.text) { (placemarks, error) in
            if error == nil {
                if let placemarks = placemarks {
                    self.placeMark = placemarks[0] as CLPlacemark
                }
                self.performSegue(withIdentifier: "segueMapStudent", sender: self)
            }else {
                self.showAlert("Address Search", message: "Address not found")
            }
            self.activityIndicator.stopAnimating()
        }
        
        
    }
   
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMapStudent" {
            let mapStudentViewController = segue.destination as! MapStudentViewController
            mapStudentViewController.placeMark = placeMark
            mapStudentViewController.mapString = address.text
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OnTheMapClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
