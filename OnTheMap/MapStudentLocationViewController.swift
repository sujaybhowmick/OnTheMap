//
//  MapStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 7/5/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit
import MapKit

class MapStudentViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    var placeMark: CLPlacemark!
    
    var mapString: String!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var webLink: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webLink.delegate = self
        self.setUpButton()
        self.placePin()
        
    }
    
    private func setUpButton(){
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 0
    }
    
    @IBAction func cancel(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabViewController") as! TabBarController
        present(controller, animated: true, completion: nil)

    }
    
    @IBAction func submit(_ sender: Any) {
        let user = OnTheMapClient.sharedInstance().user!
        let studentLocation = StudentLocation(uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName, mapString: self.mapString, mediaURL: webLink.text!, latitude: (placeMark.location?.coordinate.latitude)!, longitude: (placeMark.location?.coordinate.longitude)!)
        self.activityIndicator.startAnimating()
        OnTheMapClient.sharedInstance().postStudentLocation(studentLocation) { (success, errorString) in
            performUIUpdatesOnMain {
                
                if success {
                    print(success)
                    self.activityIndicator.stopAnimating()
                    self.showAlert("Student Post", message: "Student location, posted successfully")
                }else {
                    self.activityIndicator.stopAnimating()
                    self.showAlert("Student Post", message: "Student location, post failed")
                }
            }
            
        }
    }

    
    private func placePin() {
        let mkAnnotation = MKPointAnnotation()
        let lat = CLLocationDegrees((placeMark.location?.coordinate.latitude)!)
        let long = CLLocationDegrees((placeMark.location?.coordinate.longitude)!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mkAnnotation.coordinate = coordinate
        mapView.addAnnotation(mkAnnotation)
        
        var mkRegion = MKCoordinateRegion()
        mkRegion.center = coordinate
        mapView.setRegion(mkRegion, animated: true)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OnTheMapClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
