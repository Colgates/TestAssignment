//
//  PhotoCollectionViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import Combine
import UIKit

class PhotoCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var searchController: UISearchController!
    
    private var viewModel = PhotoSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Search"
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureDataSource()
        configureSearchController()
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            // group (leadingGroup, trailingGroup, nestedGroup)
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(1.0))
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 2)
            let trailngGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 3)
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailngGroup])
            
            // section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        // layout
        return layout
    }
    
    private func configureDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                fatalError("could not dequeue an PhotoCollectionViewCell")
            }
//            cell.imageView.sd_setImage(with: URL(string: photo.webformatURL), completed: nil)
            return cell
        })
    }
}
// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let snapshot = viewModel.dataSource?.itemIdentifier(for: indexPath)
//        guard let urlString = snapshot?.webformatURL else { return }
//        let vc = DetailViewController(imageURL: urlString)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UISearchResultsUpdating

extension PhotoCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        viewModel.searchText = text
    }
}


class PhotoSearchViewModel {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Photo>?
    
    @Published var searchText = ""
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        $searchText
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchPhotos(for: text)
            }
            .store(in: &subscriptions)
    }
    
    func searchPhotos(for query: String) {
        APIClient().searchPhotos(for: query)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] photos in
                self?.updateSnapshot(with: photos)
            }
            .store(in: &subscriptions)
    }
    
    private func updateSnapshot(with photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
