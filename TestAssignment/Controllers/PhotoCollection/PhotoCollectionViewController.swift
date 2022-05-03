//
//  PhotoCollectionViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import Combine
import SDWebImage
import UIKit

class PhotoCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var searchController: UISearchController!
    
    private var viewModel: PhotoCollectionViewModel

    init(viewModel: PhotoCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Search"
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        
        viewModel.fetchPhotos()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.autocapitalizationType = .none
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout()  -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<Int, PhotoCellViewModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                fatalError("could not dequeue an PhotoCollectionViewCell")
            }
            cell.configure(with: model)
            return cell
        })
    }
}
// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel.createViewModelForDetailsVC(for: indexPath) else { return }
        let vc = PhotoDetailsViewController(model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension PhotoCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        viewModel.searchText = text
    }
}
