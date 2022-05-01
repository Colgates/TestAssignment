//
//  FavoritesListViewModel.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import UIKit

protocol FavoritesListViewModelProtocol {
    init(networkService: NetworkServiceProtocol)
    func loadFavorites()
    func createViewModelForDetailsVC(for indexPath: IndexPath) -> DetailsViewModel?
}

class FavoritesListViewModel: FavoritesListViewModelProtocol {
    
    var dataSource: FavoritesTableViewDataSource?
    
    private let networkService: NetworkServiceProtocol
    
    required init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadFavorites() {
        let favorites = PersistenceManager.shared.fetchContext()
        let models = favorites.map { FavoritesTableViewCellViewModel(favorites: $0)}
        updateSnapshot(with: models)
    }
    
    func createViewModelForDetailsVC(for indexPath: IndexPath) -> DetailsViewModel? {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath), let id = selectedItem.id else  { return nil }
        return DetailsViewModel(id: id, networkService: networkService)
    }
    
    private func updateSnapshot(with favorites: [FavoritesTableViewCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FavoritesTableViewCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(favorites)
        dataSource?.apply(snapshot)
    }
}
