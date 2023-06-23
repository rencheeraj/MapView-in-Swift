//
//  ViewController.swift
//  MapViewSwift
//
//  Created by Rencheeraj Mohan on 21/06/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var currentVisibleCellIndexPath : IndexPath?
    private let mapView : MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    var collectionView: UICollectionView!
    let annotationLocations = [
        ["title" : "Edachira","latitude" : 10.0139 ,"longitude": 76.3710],
        ["title" : "Infopark Kochi","latitude" : 10.0116 ,"longitude": 76.3622],
        ["title" : "Smart City","latitude" : 10.0119 ,"longitude": 76.3673],
        ["title" : "Brahmapuram","latitude" : 10.0010 ,"longitude": 76.3788]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        self.view.addSubview(mapView)
        self.view.addSubview(collectionView)
        createCollectionViewNSLayout()
        collectionView.register(MapOverlayCollectionViewCell.self, forCellWithReuseIdentifier: MapOverlayCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
//        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        createAnnotation(locations: annotationLocations)
//        LocationManger.shared.getUserLocation { [weak self] loc in
//            if let currentLoc = loc {
//                self!.updateLocation(location : currentLoc)
//            }else{
////                self!.updateLocation(location : loc)
//                print("Unable to fetch")
//            }
//        }
    }
    func createCollectionViewNSLayout(){
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width)
        ])
    }
    func createAnnotation(locations : [[String : Any]]){
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            self.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)), animated: true)
            mapView.addAnnotation(annotation)
        }
        
    }
    func updateLocation(location : CLLocation, title : String){
            DispatchQueue.main.async {
                let pin = MKPointAnnotation()
                pin.title = title
                pin.coordinate = location.coordinate
                self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)), animated: true)
                self.mapView.addAnnotation(pin)
            }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = self.view.bounds
    }
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return annotationLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapOverlayCollectionViewCell.identifier, for: indexPath) as? MapOverlayCollectionViewCell
        let annotation = annotationLocations[indexPath.item]
        cell!.nameLabel.text = annotation["title"] as? String
        cell?.contentView.backgroundColor = .cyan
        return cell!
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let collectionView = scrollView as? UICollectionView else {
//            return
//        }
//
//        let visibleCells = collectionView.visibleCells
//        print(visibleCells)
//        for (index, visibleCell) in visibleCells.enumerated(){
//            guard let indexPath = collectionView.indexPath(for: visibleCell) else{
//                continue
//            }
//            print(index)
//            print(indexPath)
//            let annotation = annotationLocations[indexPath.item]
//            let location : CLLocation = CLLocation(latitude: annotation["latitude"] as! CLLocationDegrees, longitude: annotation["longitude"] as! CLLocationDegrees)
//            let title : String = annotation["title"] as! String
//            if index == 0{
//                updateLocation(location: location, title: title)
//            }else if index == visibleCells.count - 1{
//                updateLocation(location: location, title: title)
//            }else{
//                updateLocation(location: location, title: title)
//            }
//        }
//
////        for cell in visibleCells {
////            if let indexPath = collectionView.indexPath(for: cell){
////                let annotation = annotationLocations[indexPath.item]
////                let location : CLLocation = CLLocation(latitude: annotation["latitude"] as! CLLocationDegrees, longitude: annotation["longitude"] as! CLLocationDegrees)
////                let title : String = annotation["title"] as! String
////                createAnnotation(locations: [annotation])
////                updateLocation(location: location, title: title)
////            }
////        }
////        if let firstVisibleCell = visibleCells,
////           let indexPath = collectionView.indexPath(for: firstVisibleCell), indexPath != currentVisibleCellIndexPath{
////                currentVisibleCellIndexPath = indexPath
////            collectionView.scrollToItem(at: currentVisibleCellIndexPath!, at: .left, animated: true)
////                        let annotation = annotationLocations[indexPath.item]
////                        createAnnotation(locations: [annotation])
////                    }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        let annotation = annotationLocations[indexPath.item]
        let location : CLLocation = CLLocation(latitude: annotation["latitude"] as! CLLocationDegrees, longitude: annotation["longitude"] as! CLLocationDegrees)
        let title : String = annotation["title"] as! String
        updateLocation(location: location, title: title)
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//
//        visibleRect.origin = collectionView.contentOffset
//        visibleRect.size = collectionView.bounds.size
//
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//
//        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
//
//        print(indexPath)
//
//        let annotation = annotationLocations[indexPath.item]
//        let location : CLLocation = CLLocation(latitude: annotation["latitude"] as! CLLocationDegrees, longitude: annotation["longitude"] as! CLLocationDegrees)
//        let title : String = annotation["title"] as! String
//        updateLocation(location: location, title: title)
//    }
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
    }
}
