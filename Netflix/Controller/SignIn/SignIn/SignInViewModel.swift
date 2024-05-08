import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol SignInViewModelDelegate: AnyObject {
    func signInSuccess()
    func signInFailure(with error: String)
}

class SignInViewModel {
    
    weak var delegate: SignInViewModelDelegate?
    private let database = Database.database().reference()
    
    func signIn(email: String, pass: String) {
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                let errorCode = AuthErrorCode.Code(rawValue: error._code)
                self.handleSignInFailure(errorCode: errorCode?.rawValue)
            } else if let user = result?.user {
                let user = User(email: user.email ?? "", uid: user.uid)
                self.saveUserLoggedInState(for: user)
                self.delegate?.signInSuccess()
            }
        }
    }
    
    private func saveUserLoggedInState(for user: User) {
        database.child("users").child(user.uid).child("loggedIn").setValue(true)
    }    
    
    private func handleSignInFailure(errorCode: Int?) {
        if let errorCode = errorCode, let authErrorCode = AuthErrorCode.Code(rawValue: errorCode) {
            switch authErrorCode {
            case .wrongPassword:
                delegate?.signInFailure(with: "Wrong password.")
            case .userNotFound:
                delegate?.signInFailure(with: "User not found.")
            default:
                delegate?.signInFailure(with: "Email or password is invalid!")
            }
        }
    }
}
