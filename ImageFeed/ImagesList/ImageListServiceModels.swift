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
    let createdAt: String?
    let welocomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(id: String, size: CGSize, createdAt: String?, welocomeDescription: String?, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welocomeDescription = welocomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(result photo: PhotoResult) {
        self.id = photo.id
        self.size = CGSize(width: photo.width, height: photo.height)
        self.createdAt = photo.createdAt
        self.welocomeDescription = photo.description ?? ""
        self.thumbImageURL = photo.urls?.thumb ?? ""
        self.largeImageURL = photo.urls?.full ?? ""
        self.isLiked = photo.likedByUser
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let height: Int
    let width: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct LikePhotoResult: Codable {
    let photo: LikePhoto
}

struct LikePhoto: Codable {
    let id: String
    let likes: Int
    let likedByUser: Bool
}
