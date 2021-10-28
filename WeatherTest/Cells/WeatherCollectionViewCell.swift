//
//  WeatherCollectionViewCell.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 07.07.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var datalabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurateCardView()
    }

    func configurateCardView(){
        cardView.backgroundColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4010502897)
        cardView.layer.cornerRadius = 10.0
        cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3472940811)
        cardView.layer.borderWidth = 1
    }
    
}
