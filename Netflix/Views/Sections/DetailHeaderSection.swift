//
//  DetailInfoCollectionViewCell.swift
//

import Foundation
import UIKit
import SnapKit
import Cosmos
import TagListView
import Nuke

@objc protocol DetailHeaderSectionDelegate {
    func didPressReadMore(sender:DetailHeaderSection, height: CGFloat)
}

class DetailHeaderSection: UICollectionReusableView {
    
    var movieDetail: MovieDetailResponse!
    weak var delegate:DetailHeaderSectionDelegate?
    var expandingState = false
    let defaultHeightDescription : CGFloat = 120.0

    private lazy var imgBgTop: UIImageView = {
        let img = UIImageView()
        self.addSubview(img)
        return img
    }()
    
    private lazy var viewBg: UIView = {
        let outerView = UIView()
        self.addSubview(outerView)
        return outerView
    }()
    
    private lazy var imgAvatar: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = imgCornerRadius
        self.viewBg.addSubview(img)
        return img
    }()

    private lazy var title: UILabel = {
        let labelTitle = UILabel()
        labelTitle.font = UIFont(name: font_helvetica_bold, size: 24)
        labelTitle.textColor = .white
        labelTitle.textAlignment = .left
        labelTitle.adjustsFontSizeToFitWidth = true
        self.addSubview(labelTitle)
        return labelTitle
    }()
    
    private lazy var desc: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: font_helvetica, size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        self.addSubview(label)
        return label
    }()
    
    private lazy var btnPlay: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: image_detail_ic_play), for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    private lazy var btnMore: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(str_btn_read_more, for: .normal)
        btn.setTitleColor(UIColor(red: 0, green: 0.478, blue: 0.851, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: font_helvetica, size: 14)
        btn.addTarget(self, action: #selector(readMore), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    
    private lazy var btnFavorite: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: image_detail_favorite), for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    private lazy var cosmosView: CosmosView = {
        let cosmosView = CosmosView()
//        cosmosView.settings.fillMode = .full
//        cosmosView.settings.starSize = 15
//        cosmosView.settings.starMargin = 10
        cosmosView.rating = 4
//        cosmosView.settings.emptyImage = UIImage(named: image_detail_ic_star_empty)
//        cosmosView.settings.filledImage = UIImage(named: image_detail_ic_star_full)
        self.addSubview(cosmosView)
        return cosmosView
    }()
    
    private lazy var lblRating: UILabel = {
        let labelTitle = UILabel()
        labelTitle.font = UIFont(name: font_helvetica_bold, size: 18)
        labelTitle.textColor = .white
        labelTitle.textAlignment = .center
        self.addSubview(labelTitle)
        return labelTitle
    }()
    
    private lazy var lblTime: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: font_helvetica, size: 14)
        label.textColor = .white
        self.addSubview(label)
        return label
    }()
    
    private lazy var tagList: TagListView = {
        let tagListView = TagListView()
        tagListView.textFont = UIFont(name: font_helvetica, size: 12) ?? UIFont.systemFont(ofSize: 12)
        tagListView.textColor = .white
        tagListView.tagBackgroundColor = UIColor(red: 0, green: 0.478, blue: 0.851, alpha: 1)
        tagListView.alignment = .left
        tagListView.cornerRadius = 8.0
        tagListView.paddingX = 10.0
        tagListView.paddingY = 4
        tagListView.marginX = 10
        tagListView.marginY = 10
        tagListView.delegate = self
        self.addSubview(tagListView)
        return tagListView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let heightBg = fullWidth*220/360
        self.imgBgTop.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(heightBg)
        }
        
        self.btnPlay.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.imgBgTop)
            $0.size.equalTo(54)
        }
    
        self.viewBg.snp.makeConstraints {
            $0.left.equalTo(marginLeft)
            $0.height.equalTo(180)
            $0.width.equalTo(120)
            $0.top.equalTo(self.imgBgTop.snp.bottom).offset(-70)
        }
        self.viewBg.viewShadow()
        
        self.imgAvatar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.title.snp.makeConstraints {
            $0.left.equalTo(marginLeft)
            $0.right.equalTo(-marginLeft)
            $0.top.equalTo(self.imgAvatar.snp.bottom).offset(marginLeft)
            $0.height.equalTo(33)
        }
        
        self.desc.snp.makeConstraints {
            $0.left.equalTo(marginLeft)
            $0.right.equalTo(-marginLeft)
            $0.top.equalTo(self.title.snp.bottom).offset(4)
            $0.height.equalTo(120)
        }
        
        self.btnMore.snp.makeConstraints {
            $0.right.equalTo(-marginLeft)
            $0.top.equalTo(self.desc.snp.bottom).offset(7)
            $0.height.equalTo(20)
        }
        
        self.btnFavorite.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(250)
            $0.top.equalTo(self.desc.snp.bottom).offset(56)
            $0.centerX.equalTo(self.imgBgTop)
        }
        
        self.lblRating.snp.makeConstraints {
            $0.left.equalTo(self.imgAvatar.snp.right).offset(10)
            $0.top.equalTo(self.imgBgTop.snp.bottom).offset(4)
            $0.size.equalTo(26)
        }
        
        self.cosmosView.snp.makeConstraints {
            $0.left.equalTo(self.lblRating.snp.right).offset(10)
            $0.centerY.equalTo(self.lblRating)
            $0.height.equalTo(15)
            $0.width.equalTo(115)
        }
        
        self.lblTime.snp.makeConstraints {
            $0.left.equalTo(self.lblRating)
            $0.right.equalTo(-marginLeft)
            $0.height.equalTo(16)
            $0.top.equalTo(self.lblRating.snp.bottom).offset(6)
        }
        
        self.tagList.snp.makeConstraints {
            $0.left.equalTo(self.lblRating)
            $0.right.equalTo(-marginLeft)
            $0.bottom.equalTo(self.imgAvatar.snp.bottom)
            $0.top.equalTo(self.lblTime.snp.bottom).offset(9)
        }
    }
    
    @objc func readMore() {
        self.expandingState = !self.expandingState
        var height : CGFloat = 0
        
        if self.expandingState {
            height = self.desc.text!.height(withConstrainedWidth: UIScreen.main.bounds.size.width - marginLeft * 2, font: self.desc.font)
            self.btnMore.setTitle(str_btn_collapse, for: .normal)
        } else {
            height = 120
            self.btnMore.setTitle(str_btn_read_more, for: .normal)
        }
            self.desc.snp.updateConstraints { (constraint) in
                constraint.height.equalTo(height)
            }
        delegate?.didPressReadMore(sender: self, height: height)
    }
    
    func configure(movieDetail: MovieDetailResponse?) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w300/\(movieDetail?.backdrop_path ?? "")") else {return}
        self.imgBgTop.sd_setImage(with: url,placeholderImage: UIImage(named: "detail_mockup_video"), completed: nil)
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w300/\(movieDetail?.poster_path ?? "")") else {return}
        self.imgAvatar.sd_setImage(with: url,placeholderImage: UIImage(named: "imagePlaceholder"), completed: nil)
        
        self.desc.text = movieDetail?.overview
        self.title.text = movieDetail?.title
        self.lblTime.text = movieDetail?.releaseDate
        self.lblRating.text = "\(movieDetail?.rating ?? 0)"
        self.cosmosView.rating = movieDetail?.rating ?? 0
        self.cosmosView.isUserInteractionEnabled = false
        
        
        self.btnMore.isHidden = !showReadMoreButton()
    }
    
    func showReadMoreButton() -> Bool {
        if self.desc.text == nil {
            return false
        }
        let heightDesc = self.desc.text!.height(withConstrainedWidth: UIScreen.main.bounds.size.width - marginLeft * 2, font: self.desc.font);
        if heightDesc > self.defaultHeightDescription {
            return true
        }
        return false
    }
    
    func addGenre(arr:[MovieGenre]) {
        self.tagList.removeAllTags()
        for i in 0..<arr.count {
            let movie = arr[i] as MovieGenre
            self.tagList.addTag(movie.name)
        }
    }
}

extension DetailHeaderSection: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
    }
}
