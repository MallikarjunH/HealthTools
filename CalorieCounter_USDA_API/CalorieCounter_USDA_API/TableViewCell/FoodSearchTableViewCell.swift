//
//  FoodSearchTableViewCell.swift
//  CalorieCounter_USDA_API
//
//  Created by mallikarjun on 26/08/19.
//  Copyright © 2019 Mallikarjun H. All rights reserved.
//

import UIKit

class FoodSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var foodNameLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
