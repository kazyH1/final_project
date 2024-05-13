//
//  StringExtension.swift
//  Netflix
//
//  Created by Admin on 03/05/2024.
//

import Foundation
import UIKit
extension String {
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func isValidPassword(_ pass: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’/{};.%$*,]{8,}$"
        let passText = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passText.evaluate(with: pass)
    }
    public func capitalizeFirstLetter() -> String {
            return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    func getYoutubeFormattedDuration() -> String {

        let formattedDuration = self.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with:":").replacingOccurrences(of: "M", with: ":").replacingOccurrences(of: "S", with: "")

        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            duration = duration.count > 0 ? duration + ":" : duration
            if component.count < 2 {
                duration += "0" + component
                continue
            }
            if components.count < 2 {
                duration = "00:"
            }
            duration += component
        }

        return duration

    }
}
