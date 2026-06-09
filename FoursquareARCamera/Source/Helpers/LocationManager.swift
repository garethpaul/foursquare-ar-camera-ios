//
//  LocationManager.swift
//  FourquareARCamera
//
//  Created by Gareth Paul Jones on 02/07/2017.
//  Copyright © 2017 Foursquare. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager, location: CLLocation)
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager, heading: CLLocationDirection, accuracy: CLLocationDirection)
}

///Handles retrieving the location and heading from CoreLocation
///Does not contain anything related to ARKit or advanced location
class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationManagerDelegate?
    
    private var locationManager: CLLocationManager?
    
    var currentLocation: CLLocation?
    
    var heading: CLLocationDirection?
    var headingAccuracy: CLLocationDegrees?

    private func isAuthorizedForLocationUpdates(_ status: CLAuthorizationStatus) -> Bool {
        return status == CLAuthorizationStatus.authorizedAlways ||
            status == CLAuthorizationStatus.authorizedWhenInUse
    }
    
    override init() {
        super.init()
        let manager = CLLocationManager()
        self.locationManager = manager
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = kCLDistanceFilterNone
        manager.headingFilter = kCLHeadingFilterNone
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestWhenInUseAuthorization()

        if isAuthorizedForLocationUpdates(CLLocationManager.authorizationStatus()) {
            manager.startUpdatingHeading()
            manager.startUpdatingLocation()
        }
        
        self.currentLocation = manager.location
    }
    
    func requestAuthorization() {
        if isAuthorizedForLocationUpdates(CLLocationManager.authorizationStatus()) {
            return
        }
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
            return
        }
        
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isAuthorizedForLocationUpdates(status) {
            manager.startUpdatingHeading()
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.delegate?.locationManagerDidUpdateLocation(self, location: location)
        }
        
        self.currentLocation = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingValue: CLLocationDirection
        if newHeading.headingAccuracy >= 0 {
            headingValue = newHeading.trueHeading
        } else {
            headingValue = newHeading.magneticHeading
        }
        
        self.heading = headingValue
        self.headingAccuracy = newHeading.headingAccuracy
        
        self.delegate?.locationManagerDidUpdateHeading(self, heading: headingValue, accuracy: newHeading.headingAccuracy)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
