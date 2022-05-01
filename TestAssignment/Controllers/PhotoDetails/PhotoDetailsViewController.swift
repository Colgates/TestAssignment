//
//  DetailsViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 30.04.2022.
//

import Combine
import SDWebImage
import UIKit

class PhotoDetailsViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorNameLabel = CustomLabel()
    private let dateLabel = CustomLabel()
    private let locationLabel = CustomLabel()
    private let numberOfDownloadsLabel = CustomLabel()
    
    private let saveButton = CustomButton()
    
    private let viewModel: DetailsViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    init(_ viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addConstraints()
        configureButton()
        setupBindings()
        fetchPhotoDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFavorites()
    }
    
    private func addConstraints() {
        let stackView = UIStackView(arrangedSubviews: [authorNameLabel, dateLabel, locationLabel, numberOfDownloadsLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(imageView, stackView, saveButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: 10),
        ])
    }
    
    private func configureButton() {
        saveButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    private func setupBindings() {
        
        viewModel.$imageUrl
            .sink {
                self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.imageView.sd_setImage(with: URL(string: $0 ?? ""))
            }
            .store(in: &subscriptions)
        
        viewModel.$authorName
            .sink { self.authorNameLabel.text = $0 }
            .store(in: &subscriptions)
        
        viewModel.$createdAt
            .sink { self.dateLabel.text = $0 }
            .store(in: &subscriptions)
        
        viewModel.$location
            .sink { self.locationLabel.text = $0 }
            .store(in: &subscriptions)
        
        viewModel.$numberOfDownloads
            .sink { self.numberOfDownloadsLabel.text = $0 }
            .store(in: &subscriptions)
        
        viewModel.$isFavorite
            .sink { bool in
                if bool {
                    self.saveButton.setTitle("Saved!", for: .normal)
                } else {
                    self.saveButton.setTitle("Add to favorites", for: .normal)
                }
            }
            .store(in: &subscriptions)
    }
    
    func checkFavorites() {
        viewModel.checkIsFavorite()
    }
    
    private func fetchPhotoDetails() {
        viewModel.getPhotoDetails()
    }
    
    @objc private func didTapAddButton() {
        if viewModel.isFavorite {
            viewModel.deleteFromFavorites()
            viewModel.isFavorite = false
        } else {
            viewModel.saveToFavorites()
            viewModel.isFavorite = true
            presentAlertOnMainThread(title: "Hooray!🎉", message: "You have succesfully added this photo to your favorites list.", buttonTitle: "Ok")
        }
    }
}
