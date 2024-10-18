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
    private var likeTask: URLSessionTask?
    
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
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = try? makePhotosNextPageRequest(page: nextPage, perPage: perPage) else {
            return
        }
        task?.cancel()
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
                switch result {
                case .success(let response):
                    let newPhoto = response.map { Photo(result: $0)}
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhoto)
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default.post(name: ImageListService.didChageNotification, object: nil)
                    }
                case .failure(let error):
                    print("[\(String(describing: self)).\(#function)]: \(ImageListServiceErrors.invalidFetchingImagesList) -  Error fetching Image List, \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func likeRequest(photoId: String, isLike: Bool) throws -> URLRequest? {
        guard let baseUrl = Constants.defaultBaseURL else {
            throw ImageListServiceErrors.invalidURL
        }
        
        guard let url = URL(
            string: "/photos"
            + "/\(photoId)/like",
            relativeTo: baseUrl
        ) else {
            throw ImageListServiceErrors.invalidURL
        }
        var request = URLRequest(url: url)
        if isLike {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        guard let token = OAuthTokenStorage().token else {
            throw ImageListServiceErrors.invalidToken
        }
        
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ complition: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let request = try? likeRequest(photoId: photoId, isLike: isLike) else {
            return complition(.failure(ImageListServiceErrors.invalidURL))
        }
        likeTask?.cancel()
        let likeTask = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == response.photo.id }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welocomeDescription: photo.welocomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                        complition(.success(Void()))
                    }
                }
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ImageListServiceErrors.invalidLikeOperation) -  Error change like, \(error.localizedDescription)")
                complition(.failure(ImageListServiceErrors.invalidLikeOperation))
            }
            self.likeTask = nil
        }
        self.likeTask = likeTask
        likeTask.resume()
    }
    
    func deleteImagesList() {
        photos = []
    }
}
