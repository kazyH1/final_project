//
//  Utils.swift
//  Netflix
//
//  Created by HuyNguyen on 21/05/2024.
//

import Foundation
import UIKit


struct DetailSection {
    static let info = 0
    static let series = 1
    static let video = 2
//    static let comment = 3
    static let recommend = 3
}

public func heightStatusBar() -> CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return height
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}
