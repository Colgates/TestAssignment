//
//  FavoritesViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableView
    }()
    
    private let viewModel: FavoritesListViewModel
    
    init(viewModel: FavoritesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = tableView
        title = "Favorites"
        tableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
//        loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    func loadFavorites() {
        viewModel.loadFavorites()
    }
    
    func configureDataSource() {
        viewModel.dataSource = FavoritesTableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else { fatalError() }
            cell.configure(with: model)
            return cell
        })
        
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = viewModel.createViewModelForDetailsVC(for: indexPath) else { return }
        let vc = PhotoDetailsViewController(model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
