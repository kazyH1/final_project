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
                //self.saveUserLoggedInState(for: user)
                
                //save to firebase
                var members = [Member]()
                //let userID = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
                    // Get user value
                    print(snapshot.value as Any)
                    for child in snapshot.children {
                        let childSnap = child as! DataSnapshot
                        let dict = childSnap.value as! [String: Any]
                        let id = dict["id"] as? Int
                        let name = dict["name"] as? String
                        let image = dict["image"] as? String
                        members.append(Member(id: id, name: name, image: image))
                    }
                    //save members
                    Member.saveMembers(members: members)
                    
                }) { error in
                    print(error.localizedDescription)
                    //save members
                    Member.saveMembers(members: [])
                }
                
                self.delegate?.signInSuccess()
              
            }
        }
    }
    
    
    
    private func saveUserLoggedInState(for user: User) {
        database.child("users").child(user.uid).child("loggedIn").setValue(true)
    }
    
    private func handleSignInFailure(errorCode: Int?) {
        //save members
        Member.saveMembers(members: [])
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
