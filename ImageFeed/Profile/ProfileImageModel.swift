import Foundation

struct ProfileImage: Decodable {
    let large: String
    let small: String
}

struct UserResult: Decodable {
    let profileImage: ProfileImage
}
