//
//  DetailsViewController.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 03/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class DetailsViewController: UIViewController,MKMapViewDelegate {
    var ref: DatabaseReference!
    
    @IBOutlet weak var DetailImage: UIImageView!
    @IBOutlet weak var DetailName: UILabel!
    @IBOutlet weak var DetailMapView: MKMapView!
    
    @IBOutlet weak var ratingView: UISegmentedControl!
    
    var image = UIImage()
    var name = ""
    var latitude: Double?
    var longitude: Double?
    var ann: Annotation = Annotation(title: "" , coordinate: CLLocationCoordinate2D(latitude: 34.01925306236066, longitude: -118.28152770275595), subtitle: "")  // for single annotation on the map View
    var subtitle = ""
    var Rating: String? //value of selected segmented control
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DetailName.text = name
        DetailImage.image = image
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let segment: Int = ratingView.selectedSegmentIndex
        if segment == 0{
            self.Rating = "1"
        }else if segment == 1{
            self.Rating = "2"
        }else if segment == 2{
            self.Rating = "3"
        }else if segment == 3{
            self.Rating = "4"
        }else if segment == 4{
            self.Rating = "5"
        }

        if let finalRating = Rating{
        ref.child("Location").child(name).child("Rating").setValue(finalRating)
            //set value in firebase
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595), latitudinalMeters: 2000, longitudinalMeters: 2000)
        DetailMapView.setRegion(viewRegion, animated: false)
        addAnnotation()
        DetailMapView.delegate = self
     
        ref?.child("Location").child(name ).child("Rating").observeSingleEvent(of: .value, with: { (snapshot) in
            let index = Int(snapshot.value as? String ?? "1") ?? 0
            self.ratingView.selectedSegmentIndex = index - 1
            //set the selected Segment index to the previously set index value
        })
    
    }
    
    func addAnnotation(){
        let coord = CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595)
        ann = Annotation(title: name , coordinate: coord, subtitle: subtitle)
        DetailMapView.addAnnotation(ann)
        //annptation is added to the mapview
    }
    //To open the information when an annotation is selected, and add a button to open Apple maps to this.
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
            annotationView.canShowCallout = true // show the information box
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // add a button to open Apple Maps
            }
        return annotationView
    }
    //Function to open Apple maps when Information button is clicked.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let launchOptions = [MKLaunchOptionsMapCenterKey: CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595) ]
        ann.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
  

}
