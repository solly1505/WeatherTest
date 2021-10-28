//
//  CollectionTableViewCell.swift
//  WeatherTest
//
//  Created by Velveteen Rabbit on 07.07.2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
 
    @IBOutlet weak var collectionWeather: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionWeather.delegate = self
        collectionWeather.dataSource = self
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        collectionWeather.register(nib, forCellWithReuseIdentifier: "WeatherCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
    
}
