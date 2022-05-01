//
//  Button.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 01.05.2022.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(background: UIColor, title: String) {
        self.init(frame: .zero)
        configure(background: background, title: title)
    }
    
    private func configure(background: UIColor = .systemBlue, title: String = "") {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = background
        configuration.buttonSize = .large
        configuration.title = title
        self.configuration = configuration
        translatesAutoresizingMaskIntoConstraints = false
    }
}
