//
//  ListViewController.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 02/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import CoreLocation
import Nuke
import FirebaseDatabase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , CLLocationManagerDelegate{
    var ref: DatabaseReference? = nil
    let yelpAPIClient = CDYelpAPIClient(apiKey: "GmuBVXSGq4ts8A_LEkusZgNtgDep7QwQD3Qilq24VcBrOQV9v85LqqFHoprXvNBdfhfoVrXN-8XMp3hX8Ju8g-p-bu9h1HJCoojJ2urtkfGlWKFIuaI-xpS1b3MDXHYx")
    @IBOutlet weak var ListTable:UITableView!
    
    var num:Int? = nil;
    var results: Array<CDYelpBusiness> = []
    var latitude:Double?
    var location:CLLocation?
    var longitude:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        results = getResults()
        ListTable.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ListTable.delegate = self
        ListTable.dataSource = self
        results = getResults()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count  // return number of cells in the table
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ListTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListViewCellTableViewCell
        ListTable.rowHeight = UITableView.automaticDimension
        ListTable.estimatedRowHeight = UITableView.automaticDimension
        let result = self.results[indexPath.row]
        cell.Name.font = UIFont.boldSystemFont(ofSize: 17.0)
        Nuke.loadImage(with: self.results[indexPath.row].imageUrl!, into: cell.CellImage)
        cell.Name.text = result.name
      ref?.child("Location").child(result.name ?? "").child("Rating").observeSingleEvent(of: .value, with: { (snapshot) in
        cell.rating.text = snapshot.value as? String ?? "Not Yet Rated"
        // set the value of rating of each cell
      })
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 // to return the height of the cell
    }
    func getResults() -> Array<CDYelpBusiness>{
        var toReturn: Array<CDYelpBusiness> = []
        yelpAPIClient.cancelAllPendingAPIRequests()
        yelpAPIClient.searchBusinesses(byTerm: nil,
                                       location: nil,
                                       latitude: latitude ?? 34.01925306236066,
            longitude: longitude ?? -118.28152770275595,
            radius: 40000,
            categories: nil ,
            locale: CDYelpLocale.english_unitedStates,
            limit: 50,
            offset: 0,
            sortBy: .distance ,
            priceTiers: nil,
            openNow: false,
            openAt: nil,
            attributes: [.genderNeutralRestrooms] ) { (response) in
                if let response = response,
                    let businesses = response.businesses,
                    businesses.count > 0 {
                    
                    self.num = businesses.count
                    toReturn = businesses
                    self.results = businesses
                    self.ListTable.reloadData()
                }
        }
        return toReturn
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("new location: ", locations[0])
        location = locations.last!
        latitude =  location?.coordinate.latitude ?? 34.01925306236066
        longitude =  location?.coordinate.longitude ?? -118.28152770275595
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        let result = self.results[indexPath.row]
        do{
            let url = URL(string: "http://secure.hmepowerweb.com/Resources/Images/NoImageAvailableLarge.jpg")
            let data = try Data(contentsOf: self.results[indexPath.row].imageUrl ?? url!)
            dest?.image = UIImage(data: data)!
        }catch{
            print("Image failed")
        }
        
        dest?.name = result.name!
        dest?.subtitle = (result.location?.displayAddress?.joined(separator: ", "))!
        dest?.latitude = result.coordinates?.latitude
        dest?.longitude = result.coordinates?.longitude
        self.navigationController?.pushViewController(dest!, animated: true)
    }

}
