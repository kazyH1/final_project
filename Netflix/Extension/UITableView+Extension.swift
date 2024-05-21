//
//  UITableViewExtension.swift
//  Netflix
//
//  Created by HuyNguyen on 19/05/2024.
//

import Foundation
import UIKit
extension UITableView {

    fileprivate func configureLabelLayout(_ messageLabel: UILabel, isTop: Bool) {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        var labelTop: CGFloat = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 300:300)
        if isTop {
            labelTop = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 150:150)
        }
        else {
            labelTop = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 300:300)
        }
        
        messageLabel.topAnchor.constraint(equalTo: backgroundView?.topAnchor ?? NSLayoutAnchor(), constant: labelTop).isActive = true
        messageLabel.widthAnchor.constraint(equalTo: backgroundView?.widthAnchor ?? NSLayoutAnchor(), constant: -20).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: backgroundView?.centerXAnchor ?? NSLayoutAnchor(), constant: 0).isActive = true
    }

    fileprivate func configureLabel(_ message: String, isTop: Bool) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(messageLabel)
        configureLabelLayout(messageLabel, isTop: isTop)
        self.separatorStyle = .none
    }

    func setEmptyMessage(_ message: String, _ isEmpty: Bool) {
        if isEmpty {
            // instead of making the check in every TableView DataSource in the project
            configureLabel(message, isTop: false)
        }
        else {
            restore()
        }

    }
    
    func setEmptyMessageTop(_ message: String, _ isEmpty: Bool) {
        if isEmpty {
            // instead of making the check in every TableView DataSource in the project
            configureLabel(message, isTop: true)
        }
        else {
            restore()
        }

    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UICollectionView {

    fileprivate func configureLabelLayout(_ messageLabel: UILabel) {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelTop: CGFloat = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 300:300)
        messageLabel.topAnchor.constraint(equalTo: backgroundView?.topAnchor ?? NSLayoutAnchor(), constant: labelTop).isActive = true
        messageLabel.widthAnchor.constraint(equalTo: backgroundView?.widthAnchor ?? NSLayoutAnchor(), constant: -20).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: backgroundView?.centerXAnchor ?? NSLayoutAnchor(), constant: 0).isActive = true
    }

    fileprivate func configureLabel(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(messageLabel)
        configureLabelLayout(messageLabel)
    }

    func setEmptyMessage(_ message: String, _ isEmpty: Bool) {
        if isEmpty {
            // instead of making the check in every TableView DataSource in the project
            configureLabel(message)
        }
        else {
            restore()
        }

    }

    func restore() {
        self.backgroundView = nil
    }
}
