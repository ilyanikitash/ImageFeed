import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

public struct Profile {
    let username: String
    let name: String
    let bio: String?
    var loginName: String { "@\(username)" }
    
    init(username: String, firstName: String, lastName: String?, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName ?? "")"
        self.bio = bio
    }
}

