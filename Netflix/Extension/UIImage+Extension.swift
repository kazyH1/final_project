//
//  UIImage+Extension.swift
//  Netflix
//
//  Created by HuyNguyen on 20/05/2024.
//

import Foundation
import UIKit

extension UIImageView {
    
    func normalShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height:2)
    }
}
