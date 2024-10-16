import Foundation

enum Constants {
    static let accessKey = "vKl4gPjpudv3K9rPJHdk1QKPsfbfLfVf55jfA_pJSYc"
    static let secretKey = "lzKE74s5GzmJmqYCcRi_KfJjH2t-NBE8n3woN-_dGfs"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplachAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlComponentsPath = "/oauth/authorize/native"
    static let baseURL = URL(string: "https://unsplash.com")
}

enum AuthServiceErrors: Error {
    case invalidRequest
    case invalidResponse
    case invalidFetchingToken
    case invalidAccessTokenDecoding
    case invalidURL
}

enum ProfileServiceErrors: Error {
    case invalidRequest
    case invalidURL
    case invalidToken
    case invalidDecodingProfile
    case invalidFetchingProfile
}

enum ProfileImageServiceErrors: Error {
    case invalidRequest
    case invalidURL
    case invalidToken
    case invalidDecodingImage
    case invalidFetchingImage
}

enum ImageListServiceErrors: Error {
    case invalidRequest
    case invalidURL
    case invalidToken
    case invalidFetchingImagesList
    case invalidLikeOperation
}
