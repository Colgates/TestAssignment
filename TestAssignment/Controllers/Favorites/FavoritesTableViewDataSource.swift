//
//  FavoritesTableViewDataSource.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 01.05.2022.
//

import UIKit

class FavoritesTableViewDataSource: UITableViewDiffableDataSource<Int, FavoritesTableViewCellViewModel> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = snapshot()
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                item.delete()
                apply(snapshot, animatingDifferences: true)
            }
        }
    }
}
