//
//  LocationWeatherView.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/13/24.
//

import UIKit
import MapKit
import SnapKit

final class LocationWeatherView: BaseView {
    let map = MKMapView()
    var city = ""
    
    override func configureView() {
        self.addSubview(map)
        
        map.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    func configureViewWithData(lat: Double, lon: Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        map.setRegion(MKCoordinateRegion(center: center, latitudinalMeters: 50, longitudinalMeters: 50), animated: true)
        map.addAnnotation(annotation)
    }
    
    func searchLocation(point: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        map.removeAnnotations(map.annotations)
        
        geocoder.reverseGeocodeLocation(location) { mark, error in
            if error == nil, let mark, let place = mark.first {
                self.city = place.locality ?? "뭐지?"
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                annotation.title = "\(place.thoroughfare ?? "")"
                self.map.addAnnotation(annotation)
            }
        }
    }
}
