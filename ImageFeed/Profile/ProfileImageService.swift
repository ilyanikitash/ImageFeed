import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession: URLSession = .shared
    private var task: URLSessionTask?
    private(set) var profileImageURL: String?
    
    private init() {}
    
    private func makeProfileImageRequest(username: String) throws -> URLRequest {
        guard let baseUrl = Constants.defaultBaseURL else {
            throw ProfileImageServiceErrors.invalidURL
        }
        
        guard let url = URL(string: "/users/\(username)", relativeTo: baseUrl) else {
            throw ProfileImageServiceErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuthTokenStorage().token else {
            throw ProfileServiceErrors.invalidToken
        }
        
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileImageServiceErrors.invalidRequest))
            return
        }
        
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let profileImage = response.profileImage.large
                    self.profileImageURL = profileImage
                    completion(.success(profileImage))
                    NotificationCenter.default
                        .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL" : profileImage])
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(ProfileImageServiceErrors.invalidFetchingImage) -  Error fetching profile image, \(error.localizedDescription)")
                    completion(.failure(ProfileImageServiceErrors.invalidFetchingImage))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    func deleteProfileImage() {
        profileImageURL = nil
    }
}

