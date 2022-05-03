//
//  PhotoCollectionViewModel.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import Combine
import UIKit

class PhotoCollectionViewModel {
    
    @Published var searchText: String?
    
    var dataSource: UICollectionViewDiffableDataSource<Int, PhotoCellViewModel>?
    private var subscriptions: Set<AnyCancellable> = []
    
    private let networkManager: NetworkService
    
    required init(networkManager: NetworkService) {
        self.networkManager = networkManager
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        $searchText
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let text = text else { return }
                self?.searchPhotos(for: text)
            }
            .store(in: &subscriptions)
    }
    
    func fetchPhotos() {
        networkManager.fetchPhotos()
            .receive(on: RunLoop.main)
            .sink { completion in
//                print(completion)
            } receiveValue: { [weak self] photos in
                let models = photos.map { PhotoCellViewModel.init(photo: $0)}
                self?.updateSnapshot(with: models)
            }
            .store(in: &subscriptions)
    }
    
    func searchPhotos(for query: String) {
        networkManager.searchPhotos(for: query)
            .sink { completion in
//                print(completion)
            } receiveValue: { [weak self] photos in
                let models = photos.map { PhotoCellViewModel.init(photo: $0)}
                self?.updateSnapshot(with: models)
            }
            .store(in: &subscriptions)
    }
    
    func createViewModelForDetailsVC(for indexPath: IndexPath) -> DetailsViewModel? {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else  { return nil }
        return DetailsViewModel(id: selectedItem.id, networkManager: networkManager)
    }
    
    // MARK: - Private
    
    private func updateSnapshot(with photos: [PhotoCellViewModel]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoCellViewModel>()
            snapshot.deleteAllItems()
            snapshot.appendSections([0])
            snapshot.appendItems(photos)
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}
