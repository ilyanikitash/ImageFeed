//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 01.10.2024.
//

import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let didChageNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    
    private let storage = OAuthTokenStorage()
    private let perPage: Int = 10
    private let urlSession: URLSession = .shared
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {}
    
    private func makePhotosNextPageRequest(page: Int, perPage: Int) throws -> URLRequest? {
        guard let baseUrl = Constants.defaultBaseURL else {
            throw ImageListServiceErrors.invalidURL
        }
        
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
            throw ImageListServiceErrors.invalidURL
        }
        components.path = "/photos"
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        
        guard let url = components.url else {
            throw ImageListServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(storage)", forHTTPHeaderField: "Authorization")
        return request
    }
    func fetchPhotosNextPage() {
        print("fetching next page")
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = try? makePhotosNextPageRequest(page: nextPage, perPage: perPage) else {
            return
        }
        task?.cancel()
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let newPhoto = response.map { Photo(result: $0)}
                    self.photos.append(contentsOf: newPhoto)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImageListService.didChageNotification, object: nil)
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(ImageListServiceErrors.invalidFetchingImagesList) -  Error fetching Image List, \(error.localizedDescription)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
