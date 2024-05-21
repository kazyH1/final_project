//
//  BaseCollectionCell.swift
//

import Foundation
import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.sizeCollection()
        
        self.collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = .black
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.registerCell()
    }
    
    open func sizeCollection() -> CGSize {
        return .zero
    }
    
    open func registerCell() {
        
    }
}

