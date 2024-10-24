import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession: URLSession = .shared
    private let profileImageService = ProfileImageService.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() {}
    
    private func makeProfileInfoRequest() throws -> URLRequest? {
        guard let baseUrl = Constants.defaultBaseURL else {
            throw ProfileServiceErrors.invalidURL
        }
        
        guard let url = URL(string: "/me", relativeTo: baseUrl) else {
            throw ProfileServiceErrors.invalidURL
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
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileInfoRequest() else {
            completion(.failure(ProfileServiceErrors.invalidRequest))
            return
        }
        
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let profile = Profile(username: response.username,
                                          firstName: response.firstName,
                                          lastName: response.lastName,
                                          bio: response.bio)
                    self.profile = profile
                    self.profileImageService.fetchProfileImageURL(username: response.username) { _ in }
                    completion(.success(profile))
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(ProfileImageServiceErrors.invalidFetchingImage) -  Error fetching profile, \(error.localizedDescription)")
                    completion(.failure(ProfileServiceErrors.invalidFetchingProfile))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    func deleteProfileInfo() {
        profile = nil
    }
}


