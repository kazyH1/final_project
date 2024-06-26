//
//  HeaderView.swift
//  Netflix
//
//  Created by Admin on 12/04/2024.
//

import UIKit

class HeaderView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let infoButton = UIButton()
    let addMyListButton = UIButton()
    
    weak var delegate: HomeHeaderViewDelegate?
    var movie: Movie?
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.white.cgColor
        button.setTitle(" Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "playIcon"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func designButton(button: UIButton, image: String){
        let image = UIImage(named: image)
        button.setImage(image, for: .normal)
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
    }
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.designButton(button: infoButton, image: "info")
        self.designButton(button: addMyListButton, image: "addList")
        addSubview(headerImageView)
        addGradient()
        addSubview(playButton)
        addSubview(infoButton)
        addSubview(addMyListButton)
        playButton.addTarget(delegate, action: #selector(didTabButton), for: .touchUpInside)
        addMyListButton.addTarget(delegate, action: #selector(didTabMyListButton), for: .touchUpInside)
        infoButton.addTarget(delegate, action: #selector(didTapInfoButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = bounds
        gradientLayer.frame = bounds
        handleSizeClases()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func handleSizeClases() {
        let horizontalSizeClass = self.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.traitCollection.verticalSizeClass
        
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            applyContraints(buttonLeadingAnchor: 150, buttonBottomAnchor: -100, buttonWidthAnchor: 225, buttonTrailingAnchor: -150)
            addMyListButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
            infoButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        } else {
            applyContraints(buttonLeadingAnchor: 30, buttonBottomAnchor: -50, buttonWidthAnchor: 70, buttonTrailingAnchor: -30)
        }
    }
    
    private func applyContraints(buttonLeadingAnchor: Int, buttonBottomAnchor: Int, buttonWidthAnchor: Int, buttonTrailingAnchor: Int) {
        let addMyListButtonConstraints = [
            addMyListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(buttonLeadingAnchor)),
            addMyListButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(buttonBottomAnchor)),
            addMyListButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidthAnchor)),
        ]
        let infoButtonConstraints = [
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(buttonTrailingAnchor)),
            infoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(buttonBottomAnchor)),
            infoButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidthAnchor)),
        ]
        let playButtonConstrains = [
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(buttonBottomAnchor - 5)),
            playButton.heightAnchor.constraint(equalToConstant: CGFloat(40)),
            playButton.widthAnchor.constraint(equalToConstant: CGFloat(100)),
        ]
        NSLayoutConstraint.activate(playButtonConstrains)
        NSLayoutConstraint.activate(infoButtonConstraints)
        NSLayoutConstraint.activate(addMyListButtonConstraints)
    }
    
    @objc func didTabButton(){
        guard let delegate = delegate else { return }
        delegate.didTapPlayButton(movie: self.movie!)
    }
    
    @objc func didTabMyListButton(){
        guard let delegate = delegate else { return }
        delegate.didTapMyListButton()
    }
    
    @objc func didTapInfoButton(){
        guard let delegate = delegate else { return }
        delegate.didTapInfoButton(movie: self.movie!)
    }
    
    public func configure(movie: Movie) {
        self.movie = movie
        print("H: \(String(movie.id ?? 0))")
        if let posterPath = movie.poster_path {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")") else { return }
            headerImageView.sd_setImage(with: url, completed: nil)
        } else {
            // Xử lý nếu không có poster path
            // Ví dụ: hiển thị một hình ảnh mặc định hoặc ẩn hình ảnh
        }
    }
}

protocol HomeHeaderViewDelegate: AnyObject {
    func didTapPlayButton(movie: Movie)
    func didTapMyListButton()
    func didTapInfoButton(movie: Movie)
}

