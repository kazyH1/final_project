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
        Task {
            do {
                let user = try await Auth.auth().signIn(withEmail: email, password: pass).user
                let members = try await fetchUserData(for: user.uid)
                // Save members
                Member.saveMembers(members: members)
                DispatchQueue.main.async {
                    self.delegate?.signInSuccess()
                }
            } catch {
                if let error = error as NSError? {
                    let errorCode = AuthErrorCode.Code(rawValue: error._code)
                    DispatchQueue.main.async {
                        self.handleSignInFailure(errorCode: errorCode?.rawValue)
                    }
                }
            }
        }
    }
    
    private func fetchUserData(for uid: String) async throws -> [Member] {
        let snapshot = try await database.child("users").child(uid).getData()
        var members = [Member]()
        for child in snapshot.children {
            let childSnap = child as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let id = dict["id"] as? Int
            let name = dict["name"] as? String
            let image = dict["image"] as? String
            members.append(Member(id: id, name: name, image: image))
        }
        return members
    }
    
    private func handleSignInFailure(errorCode: Int?) {
        // Save members
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
