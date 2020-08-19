//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/2/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets and properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
    }
    
    // MARK: Logout
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Refresh map
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        getStudentsPins()
    }
    
    // MARK: - Add map annotations
    
    func getStudentsPins() {
        activityIndicator.startAnimating()
        UdacityClient.getStudentLocations() { locations, error in
            
            if let error = error {
                ErrorHelpers.showSimpleAlert(
                    viewController: self, title: "Failed to Get Locations", message: error as! String)
            }
            
            else {
                  self.mapView.removeAnnotations(self.annotations)
                  self.annotations.removeAll()
                  self.locations = locations ?? []
            
                  for dictionary in locations ?? [] {
                      let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                      let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                      let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                      let first = dictionary.firstName
                      let last = dictionary.lastName
                      let mediaURL = dictionary.mediaURL
                      let annotation = MKPointAnnotation()
                      annotation.coordinate = coordinate
                      annotation.title = "\(first) \(last)"
                      annotation.subtitle = mediaURL
                      self.annotations.append(annotation)
                  }
                
                  DispatchQueue.main.async {
                     self.mapView.addAnnotations(self.annotations)
                     self.activityIndicator.stopAnimating()
                  }
            }
        }
    }
    
    // MARK: - Map view data source
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
    
}
