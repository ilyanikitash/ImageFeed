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
    let createdAt: String
    let welocomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = photo.createdAt
        self.welocomeDescription = photo.description ?? ""
        self.thumbImageURL = photo.urls?.thumb ?? ""
        self.largeImageURL = photo.urls?.full ?? ""
        self.isLiked = photo.isLiked ?? false
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let height: Int
    let width: Int
    let description: String?
    let isLiked: Bool?
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}
