//
//  FavoritesListViewModel.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import UIKit

protocol FavoritesListViewModelProtocol {
    init(networkManager: NetworkService)
    func loadFavorites()
    func createViewModelForDetailsVC(for indexPath: IndexPath) -> DetailsViewModel?
}

class FavoritesListViewModel: FavoritesListViewModelProtocol {
    
    var dataSource: FavoritesTableViewDataSource?
    
    private let networkManager: NetworkService
    
    required init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    func loadFavorites() {
        let favorites = PersistenceManager.shared.fetchContext()
        let models = favorites.map { FavoritesTableViewCellViewModel(favorites: $0)}
        updateSnapshot(with: models)
    }
    
    func createViewModelForDetailsVC(for indexPath: IndexPath) -> DetailsViewModel? {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath), let id = selectedItem.id else  { return nil }
        return DetailsViewModel(id: id, networkManager: networkManager)
    }
    
    private func updateSnapshot(with favorites: [FavoritesTableViewCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FavoritesTableViewCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(favorites)
        dataSource?.apply(snapshot)
    }
}
