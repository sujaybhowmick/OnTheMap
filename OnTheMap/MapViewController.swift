//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/23/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func doLogout(_ sender: Any) {
        print("logout")
        OnTheMapClient.sharedInstance().logoutWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogout()
                }else {
                    if let errorString = errorString {
                        self.displayError(errorString)
                    }
                }
            }
        }
    }
    
    private func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String){
        print(errorString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OnTheMapClient.sharedInstance().getStudentLocations(self) { (success, errorString) in
            if success {
                print("success")
                performUIUpdatesOnMain {
                    if let studentLocations: [StudentLocation] = OnTheMapClient.sharedInstance().studentLocations {
                        var annotations = [MKPointAnnotation]()
                        for studentLocation in studentLocations {
                            let lat = CLLocationDegrees(studentLocation.latitude)
                            let long = CLLocationDegrees(studentLocation.longitude)
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                            annotations.append(annotation)
                            
                        }
                        self.mapView.addAnnotations(annotations)
                    }
                }
                
            }else {
                print("failed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
}

