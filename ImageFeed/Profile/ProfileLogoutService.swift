//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 08.10.2024.
//
import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let imageListService = ImageListService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileServie = ProfileService.shared
    private let storage = OAuthTokenStorage()
    
    private init() {}
    
    func logout() {
        imageListService.deleteImagesList()
        profileImageService.deleteProfileImage()
        profileServie.deleteProfileInfo()
        cleanCookies()
        storage.deleteToken()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
