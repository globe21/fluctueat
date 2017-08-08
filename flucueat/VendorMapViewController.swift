//
//  VendorMapViewController.swift
//  fluctueat
//
//  Created by Jake Flaten on 7/19/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class VendorMapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var mapRegion = MKCoordinateRegion()
    let mapSize = MKMapSize(width: 0.5, height: 0.5)
    let timeThisVCOpened = Date()
    var ref: DatabaseReference!


    @IBOutlet weak var vendorMapView: MKMapView!
   
    @IBOutlet weak var openUntil: UIDatePicker!
 
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.signedInStatus(isSignedIn: true)
        configureDatePicker(datePicker: openUntil)
        getLocation()
        addLocationToVendor()
        configureMapView()
        FirebaseClient.sharedInstance().configureDatabase()
    }

    @IBAction func saveTapped(_ sender: Any) {
        FirebaseClient.sharedInstance().sendVendorDataForDataBase(closingTime: getCloseTime(), totalTimeOpen: totalOpenTime())
        //sendVendorDataForDataBase()
    }
    
    func addLocationToVendor() {
        userVendor.lat = globalUserPlace.latitude
        userVendor.long = globalUserPlace.longitude
        
    }
    func configureDatePicker(datePicker: UIDatePicker) {
        let maxTime = timeThisVCOpened.addingTimeInterval(12 * 60 * 60)
        
        datePicker.minimumDate = timeThisVCOpened
        datePicker.maximumDate = maxTime
        
    }
    
    func getCloseTime() -> String {
        
        let closingTime = openUntil.date.description(with: .current)
        
       

        return closingTime
        
    }
    
    func totalOpenTime() -> String {
        let timeUntilClose: TimeInterval = openUntil.date.timeIntervalSinceNow
        let openTimeString = timeUntilClose.description
        
        return openTimeString
    }
    
//    func sendVendorDataForDataBase() {
//        var data = [String:String]()
//        data[dbConstants.name] = userVendor.name
//        data[dbConstants.description] = userVendor.description
//        data[dbConstants.lat] = "\(userVendor.lat)"
//        data[dbConstants.long] = "\(userVendor.long)"
//        data[dbConstants.closingTime] = getCloseTime()
//        data[dbConstants.totalTimeOpen] = totalOpenTime()
//        ref.childByAutoId().setValue(data)
//    }

    func getLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            vendorMapView.setCenter(userLocation, animated: true)
            userVendor.lat = userLocation.latitude
            userVendor.long = userLocation.longitude
            mapRegion = MKCoordinateRegion(center: userLocation, span: MapConstants.mapRangeSpan)
            vendorMapView.setRegion(mapRegion, animated: true)
            
            
            let userAnnotation = MKPointAnnotation()
            userAnnotation.coordinate = userLocation
            self.vendorMapView.addAnnotation(userAnnotation)
            
        }
    }
    
    func configureMapView() {
        vendorMapView.isScrollEnabled = false
        vendorMapView.isZoomEnabled = true
        vendorMapView.isPitchEnabled = false
        vendorMapView.region = mapRegion
    }
    
    func signedInStatus(isSignedIn: Bool){
        //TODO addstuff for if the user is signed in here
        
        if (isSignedIn) {
            configureDatabase()
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
}
