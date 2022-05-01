//
//  AlertViewController.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 01.05.2022.
//

import UIKit

class AlertViewController: UIViewController {
    
    private let containerView = AlertContainerView()
    private let titleLabel = CustomLabel(textAlignment: .center, fontSize: 20, fontWeight: .bold)
    private let messageLabel = CustomLabel(textAlignment: .center, fontSize: 16, fontWeight: .regular)
    
    
    private let actionButton = CustomButton(background: .systemPink, title: "OK")
    
    private var alertTitle: String?
    private var message: String?
    private var buttonTitle: String?
    
    init(alertTitle: String? = nil, message: String? = nil, buttonTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        setData()
    }
    
    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant:  padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant:  -padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureViewController() {
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.backgroundColor = .black.withAlphaComponent(0.75)
    }
    
    private func setData() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        messageLabel.text = message ?? "Unable to complete request"
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
}
