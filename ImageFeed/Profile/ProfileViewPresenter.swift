//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 21.10.2024.
//
import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func getProfile() -> Profile?
    func getAvatarURL() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    func getProfile() -> Profile? {
        guard let profile = ProfileService.shared.profile else {
            return nil
        }
        return profile
    }
    
    func getAvatarURL() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return nil}
        return url
    }
}
