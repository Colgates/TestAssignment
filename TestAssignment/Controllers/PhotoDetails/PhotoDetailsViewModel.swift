//
//  PhotoDetailsViewModel.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import Combine
import Foundation

class DetailsViewModel {
    
    private var id: String
    private let networkManager: NetworkService
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isFavorite: Bool = false
    @Published var imageUrl: String?
    @Published var authorName: String?
    @Published var createdAt: String?
    @Published var location: String?
    @Published var numberOfDownloads: String?
    
    required init(id: String, networkManager: NetworkService) {
        self.networkManager = networkManager
        self.id = id
    }
    
    func getPhotoDetails() {
        networkManager.getPhotoDetails(with: id)
            .receive(on: RunLoop.main)
            .sink { completion in
                //                print(completion)
            } receiveValue: { [weak self] photo in
                self?.updateUI(photo)
            }
            .store(in: &subscriptions)
    }
    
    func checkIsFavorite() {
        let _ = getObject()
    }
    
    func saveToFavorites() {
        guard let imageUrl = imageUrl, let authorName = authorName else { return }
        PersistenceManager.shared.createAndSaveNewObject(id: id, imageUrl: imageUrl, authorName: authorName)
    }
    
    func deleteFromFavorites() {
        guard let object = getObject() else { return }
        PersistenceManager.shared.delete(object)
    }
    
    // MARK: - Private

    private func updateUI(_ photo: Photo) {
        imageUrl = photo.urls.regular
        authorName = "Author: \(photo.user.name ?? "-")"
        createdAt = "Created: \(photo.createdAt.isoDateConverter)"
        location = "Location: \(photo.location?.title ?? "-")"
        numberOfDownloads = "Downloads: \(photo.downloads ?? 0)"
    }
    
    private func getObject() -> Favorites? {
        let object = PersistenceManager.shared.getObjectWith(id: id)
        if object != nil {
            self.isFavorite = true
            return object
        } else {
            self.isFavorite = false
            return nil
        }
    }
}
