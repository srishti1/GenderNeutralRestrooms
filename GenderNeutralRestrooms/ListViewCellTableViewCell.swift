//
//  ListViewCellTableViewCell.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 02/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import Cosmos

class ListViewCellTableViewCell: UITableViewCell {
    @IBOutlet weak var CellImage:UIImageView!
    @IBOutlet weak var Name:UILabel!
    @IBOutlet weak var Address:UILabel!
    
    @IBOutlet weak var cosmosView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
