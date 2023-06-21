//
//  ViewController.swift
//  MapViewSwift
//
//  Created by Rencheeraj Mohan on 21/06/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    private let mapView : MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(mapView)
        LocationManger.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.sync {
                guard let strongSelf =  self else {
                    return
                }
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                strongSelf.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
                strongSelf.mapView.addAnnotation(pin)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = self.view.bounds
    }
}
