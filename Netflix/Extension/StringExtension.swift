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
}
