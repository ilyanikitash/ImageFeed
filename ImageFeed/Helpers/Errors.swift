import Foundation

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
