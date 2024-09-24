import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let storage = OAuthTokenStorage()
    private let urlSession: URLSession = .shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) throws -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com") else {
            throw AuthServiceErrors.invalidURL
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseUrl
        ) else {
            throw AuthServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = try? makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.storage.token = response.accessToken
                    completion(.success(response.accessToken))
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(ProfileImageServiceErrors.invalidFetchingImage) -  Error fetching OAuth token, \(error.localizedDescription)")
                    completion(.failure(AuthServiceErrors.invalidFetchingToken))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
    


