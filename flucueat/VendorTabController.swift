//
//  VendorTabController.swift
//  
//
//  Created by Jake Flaten on 7/19/17.
//
//

import UIKit
import CoreLocation
import FirebaseAuth
import Firebase

class VendorTabController: UITabBarController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseClient.sharedInstance.configureAuth(vc: self)
        if !userVendor.isAuthorizedVendor {
         FirebaseClient.sharedInstance.loginSession(presentingVC: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !userVendor.isAuthorizedVendor {
            FirebaseClient.sharedInstance.checkIfVendor(vc: self)
        }
    }
    
}
