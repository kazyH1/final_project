//
//  UIColorExtension.swift
//  Netflix
//
//  Created by Admin on 03/05/2024.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(hex: String) {
           var chars = Array(hex.hasPrefix("#") ? hex.dropFirst() : hex[...])
           let red, green, blue, alpha: CGFloat
           switch chars.count {
           case 3:
               chars = chars.flatMap { [$0, $0] }
               fallthrough
           case 6:
               chars = ["F","F"] + chars
               fallthrough
           case 8:
               red   = CGFloat(strtoul(String(chars[1...2]), nil, 16)) / 255
               green = CGFloat(strtoul(String(chars[3...4]), nil, 16)) / 255
               blue  = CGFloat(strtoul(String(chars[5...6]), nil, 16)) / 255
               alpha = CGFloat(strtoul(String(chars[7...8]), nil, 16)) / 255
           default:
               red = 1; green = 1; blue = 1; alpha = 1
           }
           self.init(red: red, green: green, blue: blue, alpha: alpha)
       }
}
