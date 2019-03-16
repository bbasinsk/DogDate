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
    var shelter: Shelter
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, shelter: Shelter) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.shelter = shelter
    }
}

class BrowseSheltersMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ShelterAnnotation.self))
        
        shelters.forEach({ shelter in
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
    
    func attachCoordinates(shelter: Shelter) {
        let shelterData = shelter.shelter
        guard let coords = shelterData.coordinates else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude:coords[1])
        mapView.addAnnotation(ShelterAnnotation(title: shelterData.name, subtitle: shelterData.hours, coordinate: coordinate, shelter: shelter))
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
            let shelterAnnotation = annotation as! ShelterAnnotation
            
            if let BrowseDogsViewController = storyboard?.instantiateViewController(withIdentifier: "BrowseDogsViewController") {
                let browseDogsVC = BrowseDogsViewController as! BrowseDogsViewController
                BrowseDogsViewController.modalPresentationStyle = .popover

                // additional setup
                browseDogsVC.currentShelter = shelterAnnotation.shelter
                let shelterIdx = shelters.firstIndex(of: shelterAnnotation.shelter)!
                dogs = dogsByShelter[shelterIdx + 1]!
                filteredDogs = Array(0...(dogsByShelter[shelterIdx + 1]!.count - 1))
                
                present(browseDogsVC, animated: true, completion: nil)
            }
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

            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            rightButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        
        return view
    }
}
