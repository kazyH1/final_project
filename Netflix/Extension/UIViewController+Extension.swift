//
//  UIViewController+Extension.swift
//  Netflix
//
//  Created by Admin on 02/05/2024.
//

import Foundation
import UIKit

var vSpinner : UIView?
var keyWindow: UIWindow?
var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(white: 0, alpha: 0)
        activityIndicator.center = spinnerView.center
        activityIndicator.assignColor(UIColor("#fe0202"))
        
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    activityIndicator.frame = CGRect(x: window.frame.width/2, y: window.frame.height/2, width: 0, height: 0)
                    keyWindow = window
                }
            }
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
            keyWindow?.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    
    func removeSpinner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        style = UIActivityIndicatorView.Style.large
        self.color = color
    }
}
