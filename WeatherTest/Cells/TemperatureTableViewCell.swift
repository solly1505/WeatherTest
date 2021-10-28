//
//  TemperatureTableViewCell.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 07.07.2021.
//

import UIKit

class TemperatureTableViewCell: UITableViewCell {
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var explanationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
