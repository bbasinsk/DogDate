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

class BrowseSheltersMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var shelters : [Shelter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 47.66, longitude: -122.31)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(coordinateRegion, animated: true)
        
        shelters.forEach({ s in
            let shelter = s.shelter
            NSLog(shelter.name)
            attachCoordinates(shelter: shelter)
        })
        
    }
    
    func attachCoordinates(shelter: JSONShelter) {
        guard let coords = shelter.coordinates else {return}
        
        let annotation = MKPointAnnotation()
        annotation.title = shelter.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude:coords[1])
        mapView.addAnnotation(annotation)
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
