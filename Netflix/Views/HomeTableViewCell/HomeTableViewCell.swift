//
//  HomeTableViewCell.swift
//  Netflix
//
//  Created by Admin on 12/04/2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func registerCollecTionView() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

extension  HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 400)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return .init()}
        cell.backgroundColor = .brown
        return cell
    }
}
