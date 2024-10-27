//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 21.10.2024.
//

import Foundation

enum Constants {
    static let accessKey = "vKl4gPjpudv3K9rPJHdk1QKPsfbfLfVf55jfA_pJSYc"
    static let secretKey = "lzKE74s5GzmJmqYCcRi_KfJjH2t-NBE8n3woN-_dGfs"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlComponentsPath = "/oauth/authorize/native"
    static let baseURL = URL(string: "https://unsplash.com")
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let unsplashAuthorizeURLString: String
    let urlComponentsPath: String
    let baseURL: URL?
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL?, unsplashAuthorizeURLString: String, urlComponentsPath: String, baseURL: URL?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.urlComponentsPath = urlComponentsPath
        self.baseURL = baseURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
                                 urlComponentsPath: Constants.urlComponentsPath,
                                 baseURL: Constants.baseURL)
    }
}
