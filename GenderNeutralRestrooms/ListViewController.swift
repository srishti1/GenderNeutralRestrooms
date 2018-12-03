//
//  ListViewController.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 02/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let yelpAPIClient = CDYelpAPIClient(apiKey: "GmuBVXSGq4ts8A_LEkusZgNtgDep7QwQD3Qilq24VcBrOQV9v85LqqFHoprXvNBdfhfoVrXN-8XMp3hX8Ju8g-p-bu9h1HJCoojJ2urtkfGlWKFIuaI-xpS1b3MDXHYx")
    @IBOutlet weak var ListTable:UITableView!
    var num:Int? = nil;
    var results: Array<CDYelpBusiness> = []
    var userLocation: MapViewController!
    

    override func viewDidLoad() {
        ListTable.delegate = self
        ListTable.dataSource = self
        super.viewDidLoad()
        yelpAPIClient.cancelAllPendingAPIRequests()
        yelpAPIClient.searchBusinesses(byTerm: nil,
                                       location: nil,
                                       latitude: 34.01925306236066, //userLocation.latitude,
                                       longitude: -118.28152770275595, //userLocation.longitude,
                                       radius: 40000,
                                       categories: nil ,
                                       locale: CDYelpLocale.english_unitedStates,
                                       limit: 40,
                                       offset: 0,
                                       sortBy: nil,
                                       priceTiers: nil,
                                       openNow: false,
                                       openAt: nil,
                                       attributes: [.genderNeutralRestrooms] ) { (response) in
                                        
                                        if let response = response,
                                            let businesses = response.businesses,
                                            businesses.count > 0 {
                                            self.num = businesses.count
                                            self.results = businesses
                                            print(businesses[0].name ?? "no name");
                                            print(businesses[1].name ?? "no name");
                                            print(businesses[2].name ?? "no name");
                                            print(businesses[3].name ?? "no name");
                                            print(businesses[4].name ?? "no name");
                                            print(businesses[5].name ?? "no name");
                                            print(businesses[6].name ?? "no name");
                                            print(businesses[7].name ?? "no name");
                                            print(businesses[8].name ?? "no name");
                                            print(businesses[9].name ?? "no name");
                                        }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let a = num{
            return a;
        }else{
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListTable.dequeueReusableCell(withIdentifier: "Cell") as! ListViewCellTableViewCell
        let result = self.results[indexPath.row]
        cell.textLabel?.text = result.name
        cell.detailTextLabel?.text = result.location?.addressOne
        
        return cell
    }

}
