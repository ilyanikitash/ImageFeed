import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "token")
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "token")
            }
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "token")
    }
}
