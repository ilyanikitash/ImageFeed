//
//  Photo.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 01.10.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welocomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = ISO8601DateFormatter().date(from: photo.createdAt)
        self.welocomeDescription = photo.description ?? ""
        self.thumbImageURL = photo.urls?.thumbURL ?? ""
        self.largeImageURL = photo.urls?.largeURL ?? ""
        self.isLiked = photo.isLiked ?? false
    }
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let isLiked: Bool?
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let thumbURL: String
    let largeURL: String
}
