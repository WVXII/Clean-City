//
//  MapViewController.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 18/08/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate{
    func didLocalize(localization: String) -> String
}

class MapViewController: UIViewController, RubbishDataDelegate {
    /*func ImportRubbishData(rubbishData: [Rubbish]) {
        for rubbish in rubbishData {
        print("location: \(rubbish.location)")
        }
    }*/
    
    var rubbish: Rubbish?
    var brandi = CLLocationCoordinate2DMake(40.836724, 14.2468766)
    let mapView = MKMapView()
    //var rubbishData: Rubbish?
    var delegate:MapViewControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = view.frame
        view.addSubview(mapView)
        mapView.mapType = .satelliteFlyover
        //afficher la position actuelle
        let camera = MKMapCamera(lookingAtCenter: brandi, fromDistance: 50, pitch: 30, heading: 262)
        mapView.camera = camera
        //Add a map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = brandi
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

    func ImportRubbishData(rubbishData: [Rubbish]) {
        for rubbish in rubbishData {
        print("longitude: \(rubbish.longitude)", "latitude: \(rubbish.latitude)")
        //brandi = CLLocationCoordinate2DMake(rubbish.longitude, rubbish.latitude)
        }
    }
    
}
