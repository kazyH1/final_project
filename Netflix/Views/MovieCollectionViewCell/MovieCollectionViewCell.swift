//
//  MovieCollectionViewCell.swift
//  Netflix
//
//  Created by Admin on 12/04/2024.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
          guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
          posterImageView.sd_setImage(with: url, completed: nil)
      }
}
