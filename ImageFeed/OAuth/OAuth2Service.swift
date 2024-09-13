import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let storage = OAuthTokenStorage()
    
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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        guard let request = try? makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceErrors.invalidRequest))
            return
        }
        URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let decoder = SnakeCaseJSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = response.accessToken
                    completion(.success(response.accessToken))
                } catch {
                    print("Error decoding OAuth token response: \(error.localizedDescription)")
                    completion(.failure(AuthServiceErrors.invalidAccessTokenDecoding))
                }
            case .failure(let error):
                print("Error fetching OAuth token: \(error.localizedDescription)")
                completion(.failure(AuthServiceErrors.invalidFetchingToken))
            }
        }.resume()
    }
}
    


