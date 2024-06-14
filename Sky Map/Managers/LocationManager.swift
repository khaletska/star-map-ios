//
//  LocationManager.swift
//  Sky Map
//
//  Created by Tom Bastable on 29/04/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    let manager = CLLocationManager()
    var locationUpdateHandler: ((CLLocation?, Error?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAuthorization()
    }
    
    func requestLocationAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startReceivingLocationChanges() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Current location: \(location)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location authorization granted.")
            startReceivingLocationChanges()
            if ARViewModel.shared.loadObjects == false {
                ARViewModel.shared.loadObjects = true
            }
        case .denied, .restricted:
            print("Location authorization denied.")
        default:
            print("Location authorization status changed.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func getCurrentLocation() -> CLLocation? {
        manager.requestLocation()
        return manager.location
    }
}
