//
//  ListMovieViewController.swift
//  Netflix
//
//  Created by Admin on 17/04/2024.
//

import UIKit

class ListMovieViewController: UIViewController {
    @IBOutlet weak var listMovieCollectiovView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollecTionView()
        // Do any additional setup after loading the view.
    }
    
    func registerCollecTionView() {
        listMovieCollectiovView.delegate = self
        listMovieCollectiovView.dataSource = self
        listMovieCollectiovView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

extension ListMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listMovieCollectiovView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return .init()}
        cell.backgroundColor = .brown
        return cell
    }
}
