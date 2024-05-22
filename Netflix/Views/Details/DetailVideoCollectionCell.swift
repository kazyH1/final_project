//
//  DetailVideoCollectionCell.swift
//

import Foundation
import UIKit
import AVKit
protocol DetailVideoCellDelegate: AnyObject {
    func didSelectMovie(video: Video, posterPath: String)
}


class DetailVideoCollectionCell: BaseCollectionCell {
    
    var arrVideos = [Video]()
    weak var delegate: DetailVideoCellDelegate?
    
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

extension DetailVideoCollectionCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
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
        delegate?.didSelectMovie(video: video, posterPath: posterPath)
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
