//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/23/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBAction func addStudentLocation(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddStudentLocationController") as! AddLocationViewController
        
        present(controller, animated: true, completion: nil)
    }

    @IBAction func refresh(_ sender: Any) {
        self.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnTheMapCell")!
        let studentLocation = StudentLocationCollection.get(atIndex: indexPath.row)
        
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentLocationCollection.get(atIndex: indexPath.row)
        if let url = URL(string: studentLocation.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
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
        dismiss(animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String){
        print(errorString)
    }
    
    private func reloadData() {
        OnTheMapClient.sharedInstance().getStudentLocations(self) { (success, errorString) in
            if success {
                print("success")
                performUIUpdatesOnMain {
                    self.tableView!.reloadData()
                }
            }else {
                print("failed")
            }
        }
    }
    


}

