//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Ilya Nikitash on 22.10.2024.
//

import Foundation

public protocol ImagesListViewProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter { get }
    var dateFormatterISO8601: ISO8601DateFormatter { get }
    
    func viewDidLoad()
    func configFormatter()
}

final class ImagesListPresenter: ImagesListViewProtocol {
    var dateFormatter: DateFormatter = DateFormatter()
    var dateFormatterISO8601: ISO8601DateFormatter = ISO8601DateFormatter()
    
    weak var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        configFormatter()
    }
    
    func configFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
}
