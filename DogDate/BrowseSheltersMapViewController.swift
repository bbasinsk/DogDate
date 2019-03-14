//
//  BrowseSheltersMapViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/10/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit
import MapKit
import Contacts


class ShelterAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String? = "Title"
    var subtitle: String? = "Subtitle"
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

class BrowseSheltersMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var shelters : [Shelter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ShelterAnnotation.self))
        
        shelters.forEach({ s in
            let shelter = s.shelter
            NSLog(shelter.name)
            attachCoordinates(shelter: shelter)
        })
        
        centerMap()
    }
    
    func centerMap() {
        let initialLocation = CLLocation(latitude: 47.66, longitude: -122.31)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func attachCoordinates(shelter: JSONShelter) {
        guard let coords = shelter.coordinates else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude:coords[1])
        mapView.addAnnotation(ShelterAnnotation(title: shelter.name, subtitle: shelter.hours, coordinate: coordinate))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BrowseSheltersMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation, annotation.isKind(of: ShelterAnnotation.self) {
            print("Tapped Shelter annotation accessory view")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? ShelterAnnotation {
            annotationView = setupAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }

    private func setupAnnotationView(for annotation: ShelterAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = NSStringFromClass(ShelterAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true

            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
}
