//
//  FavoritesTableViewCell.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import SDWebImage
import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FavoritesTableViewCell.self)
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorNameLabel = CustomLabel(textAlignment: .center, fontSize: 18, fontWeight: .bold)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        contentView.addSubviews(photoImageView, authorNameLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            photoImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            authorNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorNameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            authorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with model: FavoritesTableViewCellViewModel) {
        photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photoImageView.sd_setImage(with: URL(string: model.imageUrl ?? ""))
        authorNameLabel.text = model.authorName
    }
}

struct FavoritesTableViewCellViewModel: Hashable {
    
    private var favorites: Favorites
    
    init(favorites: Favorites) {
        self.favorites = favorites
    }
    
    var id: String? {
        favorites.id
    }
    
    var imageUrl: String? {
        favorites.imageUrl
    }
    
    var authorName: String? {
        favorites.authorName
    }
    
    func delete() {
        PersistenceManager.shared.delete(favorites)
    }
}
