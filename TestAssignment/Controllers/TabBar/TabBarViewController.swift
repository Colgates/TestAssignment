//
//  ViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemBackground
        setupTabs()
    }
    
    private func setupTabs() {
        let networkService: NetworkServiceProtocol = NetworkService()
        
        let photoCollectionViewModel = PhotoCollectionViewModel(networkService: networkService)
        let photoCollectionVC = UINavigationController(rootViewController: PhotoCollectionViewController(viewModel: photoCollectionViewModel))
        photoCollectionVC.tabBarItem = UITabBarItem(title: "Photos", image: Constants.Images.house, tag: 1)
        
        let favoritesListViewModel = FavoritesListViewModel(networkService: networkService)
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController(viewModel: favoritesListViewModel))
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: Constants.Images.favorites, tag: 2)
        
        viewControllers = [photoCollectionVC, favoritesVC]
    }
}

