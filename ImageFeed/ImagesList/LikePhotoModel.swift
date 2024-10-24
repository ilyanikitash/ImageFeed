//
//  LikePhotoModel.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 18.10.2024.
//

struct LikePhoto: Codable {
    let id: String
    let likes: Int
    let likedByUser: Bool
}

struct LikePhotoResult: Codable {
    let photo: LikePhoto
}
