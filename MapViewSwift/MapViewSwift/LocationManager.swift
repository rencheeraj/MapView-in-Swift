//
//  LocationManager.swift
//  MapViewSwift
//
//  Created by Rencheeraj Mohan on 21/06/23.
//

import Foundation
import CoreLocation

class LocationManger : NSObject ,CLLocationManagerDelegate{
    static let shared = LocationManger()
    var completion : ((CLLocation) -> Void)?
    let manager = CLLocationManager()
    
    public func getUserLocation(completion : @escaping ((CLLocation) -> Void)) {
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{
            return
        }
        completion?(location)
//        manager.stopUpdatingLocation()
    }
}
