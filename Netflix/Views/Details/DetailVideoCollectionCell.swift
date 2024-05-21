//
//  DetailVideoCollectionCell.swift
//

import Foundation
import UIKit
import AVKit

class DetailVideoCollectionCell: BaseCollectionCell {
    
    var arrVideos = [Video]()
    
    override func sizeCollection() -> CGSize {
        return size_detail_video
    }
    
    override func registerCell() {
        self.collectionView.register(DetailVideoViewCell.self, self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .black
    }
    
}

extension DetailVideoCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailVideoViewCell.self), for: indexPath) as? DetailVideoViewCell else {
            fatalError()
        }
        cell.configure(video: self.arrVideos[indexPath.row])
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = self.arrVideos[indexPath.row]
        
        let posterPath = "https://img.youtube.com/vi/\(video.key)/0.jpg"
        let watchingMovieVC = WatchingMovieViewController()
        watchingMovieVC.movie = Movie(id: nil, key: video.key, media_type: nil, original_name: nil, original_title: video.name, poster_path: posterPath, backdrop_path: nil, overview: nil, vote_count: 0, release_date: nil, vote_average: 100)
        UIViewController().navigationController?.pushViewController(watchingMovieVC, animated: true)
    }
    
}

extension DetailVideoCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: marginCell, bottom: 0, right: marginCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingCell
    }
    
}
