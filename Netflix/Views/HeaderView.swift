//
//  HeaderView.swift
//  Netflix
//
//  Created by Admin on 12/04/2024.
//

import UIKit

class HeaderView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    private let playButton = UIButton()
    private let downloadButton = UIButton()
    private let addMyListButton = UIButton()
    
    func designButton(button: UIButton, title: String){
        button.setTitle(title, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.backgroundColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
    }
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "headerImage")
        return imageView
    }()
    
    private func addGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.gray.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.designButton(button: downloadButton, title: "Download")
        self.designButton(button: playButton, title: "Play")
        addSubview(headerImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
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
            playButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
            downloadButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        } else {
            applyContraints(buttonLeadingAnchor: 50, buttonBottomAnchor: -50, buttonWidthAnchor: 120, buttonTrailingAnchor: -50)
        }
    }
    
    private func applyContraints(buttonLeadingAnchor: Int, buttonBottomAnchor: Int, buttonWidthAnchor: Int, buttonTrailingAnchor: Int) {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(buttonLeadingAnchor)),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(buttonBottomAnchor)),
            playButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidthAnchor)),
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(buttonTrailingAnchor)),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(buttonBottomAnchor)),
            downloadButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidthAnchor)),
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
