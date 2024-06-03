//
//  UserInfoCollectionViewCell.swift
//  Netflix
//
//  Created by HuyNguyen on 26/05/2024.
//

import Foundation
import UIKit
import SDWebImage
class UserInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserInfoCollectionViewCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(posterImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor, constant: 0).isActive = true
        titleLabel.sizeToFit()
    }
    
    public func configure(with member: Member) {
        guard let url = URL(string: member.image ?? "") else {return}
        posterImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "imagePlaceholder"), completed: nil)
        titleLabel.text = member.name ?? ""
        titleLabel.textColor = .white
    }
}
