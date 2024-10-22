//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 22.10.2024.
//

import Foundation

public protocol ImagesListViewProtocol {
    var view: ImagesListViewControllerPresenter? { get set }
}

final class ImagesListPresenter: ImagesListViewProtocol {
    weak var view: ImagesListViewControllerPresenter?
}
