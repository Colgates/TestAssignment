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
        let photoCollectionVC = UINavigationController(rootViewController: PhotoCollectionViewController())
        photoCollectionVC.tabBarItem = UITabBarItem(title: "Photos", image: Constants.Images.house, tag: 1)
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: Constants.Images.favorites, tag: 2)
        
        viewControllers = [photoCollectionVC, favoritesVC]
    }
}

struct Constants {
    struct Images {
        static let house = UIImage(systemName: "house")
        static let favorites = UIImage(systemName: "star")
    }
}

