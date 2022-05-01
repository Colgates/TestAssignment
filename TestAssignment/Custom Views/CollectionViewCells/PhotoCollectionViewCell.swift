//
//  PhotoCollectionViewCell.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import SDWebImage
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
 
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addConstraints() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with viewModel: PhotoCellViewModel) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: viewModel.imageUrl))
    }
}

struct PhotoCellViewModel: Hashable {
    
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var id: String {
        photo.id
    }
    
    var imageUrl: String {
        photo.urls.small
    }
}

