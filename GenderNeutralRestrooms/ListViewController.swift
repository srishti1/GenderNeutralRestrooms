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
import Cosmos
import ChameleonFramework
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = ListTable.dequeueReusableCell(withIdentifier: "Cell")!
//        let result = self.results[indexPath.row]
//        cell.textLabel?.text = result.name
//        cell.detailTextLabel?.text = result.location?.addressOne
//        return cell
        
        let cell = ListTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListViewCellTableViewCell
        ListTable.rowHeight = UITableView.automaticDimension
        ListTable.estimatedRowHeight = UITableView.automaticDimension
        let result = self.results[indexPath.row]
        
        Nuke.loadImage(with: self.results[indexPath.row].imageUrl!, into: cell.CellImage)
        
        
        //cell.CellImage = self.results[indexPath.row].imageUrl
        cell.Name.text = result.name
        cell.Address.text = result.location?.displayAddress?.joined(separator: ", ")//result.location?.addressOne
        cell.backgroundColor = generateRandomPastelColor(withMixedColor: .white )
        
//        let rect = ListTable.rectForRow(at: indexPath)
//        let rectInScreen = ListTable.convert(rect, to: ListTable.superview)
        cell.backgroundColor = UIColor(gradientStyle: .topToBottom,
                                       withFrame: cell.frame,
                                       andColors: [.flatYellow, .flatYellowDark, .flatOrange])
        
//        
//        ref?.child("Location").child(result.name!).child("Rating").observeSingleEvent(of: .value, with: { (snapshot) in
//            cell.cosmosView.rating = snapshot.value ?? 0
//        }
        
        
        //cell.cosmosView.rating = 4
        cell.cosmosView.settings.updateOnTouch = false
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func getResults() -> Array<CDYelpBusiness>{
        var toReturn: Array<CDYelpBusiness> = []
        yelpAPIClient.cancelAllPendingAPIRequests()
        yelpAPIClient.searchBusinesses(byTerm: nil,
                                       location: nil,
                                       latitude: latitude ?? 34.01925306236066, //userLocation.latitude,
            longitude: longitude ?? -118.28152770275595, //userLocation.longitude,
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
        //location = (locations.last as! CLLocation)
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
    
    
    //This function is taken from https://gist.github.com/JohnCoates/725d6d3c5a07c4756dec

    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
