//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/15/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import UIKit
import MapKit
import AVKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets and properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var moviePlayer: AVPlayer?
    
    var objectId: String?
    
    var locationTextFieldIsEmpty = true
    var websiteTextFieldIsEmpty = true
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
        buttonEnabled(false, button: findLocationButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up video in the background
        setUpVideo()
    }
    
    // MARK: - call the video
    
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "Map", ofType: "mp4")
        guard bundlePath != nil else {return}
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        let videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        // Adjust the size and frame
        videoPlayerLayer.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer, at: 0)
        
        // Add it to the view and play it
        videoPlayer.playImmediately(atRate: 0.5)
    
    }
    

    
    
    // MARK: Cancel out of adding location
    
    @IBAction func cancelAddLocation(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Find location action
    
    @IBAction func findLocation(sender: UIButton) {
        self.setLoading(true)
        let newLocation = locationTextField.text
        
        let http = "https://"
        let webLink = websiteTextField.text
        let urlLink = http + webLink!
        print(urlLink)
        
        guard let url = URL(string: webLink!), UIApplication.shared.canOpenURL(url)
            else {self.showAlert(message: "Please eneter a valid URL, make sure you use http://", title: "Invalid URL")
                  setLoading(false)
                  return}
            print(url)
        geocodePosition(newLocation: newLocation ?? "")
    }
    
    // MARK: Find geocode position
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                    self.setLoading(false)
                    print("There was an error.")
                }
            }
        }
    }
    
    // MARK: Push to Final Add Location screen
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CompleteAddLocationViewController") as! CompleteAddLocationViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Student info to display on Final Add Location screen
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentAttributes {
        
        var studentInfo = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }

        return StudentAttributes(studentInfo)

    }
    
    // MARK: Loading state
    
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.findLocationButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.findLocationButton)
            }
        }
        DispatchQueue.main.async {
            self.locationTextField.isEnabled = !loading
            self.websiteTextField.isEnabled = !loading
            self.findLocationButton.isEnabled = !loading
        }
    }
    
     // MARK: Enable and Disable Buttons and Text Fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == locationTextField {
            let currenText = locationTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                locationTextFieldIsEmpty = true
            } else {
                locationTextFieldIsEmpty = false
            }
        }
        
        if textField == websiteTextField {
            let currenText = websiteTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                websiteTextFieldIsEmpty = true
            } else {
                websiteTextFieldIsEmpty = false
            }
        }
        
        if locationTextFieldIsEmpty == false && websiteTextFieldIsEmpty == false {
            buttonEnabled(true, button: findLocationButton)
        } else {
            buttonEnabled(false, button: findLocationButton)
        }
        
        return true
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: findLocationButton)
        if textField == locationTextField {
            locationTextFieldIsEmpty = true
        }
        if textField == websiteTextField {
            websiteTextFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocation(sender: findLocationButton)
            
        }
        return true
    }
   
}
