//
//  SignInViewModel.swift
//  Netflix
//
//  Created by Admin on 02/05/2024.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignInViewModel {
    
    enum AuthError: Error {
        case wrongPassword
        case userNotFound
        case unknownError
    }
    
    static let shared = SignInViewModel()
    private let database = Database.database().reference()
    
    func signIn(email: String, pass: String) async throws {
        do {
            let userCredential = try await Auth.auth().signIn(withEmail: email, password: pass)
            let user = User(email: userCredential.user.email ?? "", uid: userCredential.user.uid)
                saveUserLoggedInState()
        } catch let error as NSError {
            switch error._code {
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.userNotFound.rawValue:
                throw AuthError.userNotFound
            default:
                throw AuthError.unknownError
                print("Firebase error code: \(error.code)")
                print("Firebase error message: \(error.localizedDescription)")
            }
        }
    }
    
    func saveUserLoggedInState() {
        if let uid = Auth.auth().currentUser?.uid {
            database.child("users").child("uid1").child("loggedIn").setValue(true)
        }
    }
    
    func clearUserLoggedInState() {
        if let uid = Auth.auth().currentUser?.uid {
            database.child("users").child("uid1").child("loggedIn").setValue(false)
        }
    }
    
    func isUserLoggedIn(completion: @escaping (Bool) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            database.child("users").child("uid1").child("loggedIn").observeSingleEvent(of: .value) { snapshot in
                completion(snapshot.exists())
            }
        } else {
            completion(false)
        }
    }
}
