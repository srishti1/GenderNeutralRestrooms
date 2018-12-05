//
//  DetailsViewController.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 03/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
//import FirebaseDatabase

class DetailsViewController: UIViewController,MKMapViewDelegate {
    //let ref = Database.database().reference()

    @IBOutlet weak var DetailImage: UIImageView!
    @IBOutlet weak var DetailName: UILabel!
    @IBOutlet weak var DetailMapView: MKMapView!
    @IBOutlet weak var cosmosView: CosmosView!
    var image = UIImage()
    var name = ""
    var latitude: Double?
    var longitude: Double?
    var ann: Annotation = Annotation(title: "" , coordinate: CLLocationCoordinate2D(latitude: 34.01925306236066, longitude: -118.28152770275595), subtitle: "")
    var subtitle = ""
    var Rating: Double?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DetailName.text = name
        DetailImage.image = image
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if let finalRating = Rating{
//            ref.child("Location/Rating").setValue(finalRating)
//            ref.child("Location/Name").setValue(name)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595), latitudinalMeters: 2000, longitudinalMeters: 2000)
        DetailMapView.setRegion(viewRegion, animated: false)
        addAnnotation()
        DetailMapView.delegate = self

        // Do any additional setup after loading the view.
        cosmosView.settings.fillMode = .precise
        cosmosView.didTouchCosmos = {rating in
            self.Rating =  rating
        }
        cosmosView.didTouchCosmos = { rating in
            self.Rating =  rating
        }
    
    }
    
    func addAnnotation(){
        let coord = CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595)
        ann = Annotation(title: name , coordinate: coord, subtitle: subtitle)
        DetailMapView.addAnnotation(ann)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is Annotation else{
            return nil
        }
        let identifier = "Marker"
        var annotationView:MKMarkerAnnotationView
        if let dequeuedView = DetailMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?
            MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        }else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let launchOptions = [MKLaunchOptionsMapCenterKey: CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595) ]
        ann.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
  

}
