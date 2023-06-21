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
    var completion : ((CLLocation?) -> Void)?
    let manager = CLLocationManager()
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
    
    public func getUserLocation(completion : @escaping ((CLLocation?) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {[self] in
            if CLLocationManager.locationServicesEnabled(){
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.startUpdatingLocation()
            }else {
                completion(nil)
            }
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{
            return
        }
        manager.stopUpdatingLocation()
        completion?(location)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location update error: \(error.localizedDescription)")
        completion?(nil)
        }
}
