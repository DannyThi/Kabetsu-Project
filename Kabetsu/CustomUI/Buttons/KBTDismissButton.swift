//
//  KBTDismissButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/05.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTDismissButton: UIButton {
    override var bounds: CGRect {
        didSet {
            updateUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureButton() {
        let image = UIImage(systemName: GlobalImageKeys.dismiss.rawValue, withConfiguration: GlobalImageKeys.symbolConfig())
        self.setImage(image, for: .normal)
        self.backgroundColor = .systemGreen
        self.tintColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    private func updateUI() {
        self.layer.cornerRadius = self.bounds.height / 2
        switch traitCollection.userInterfaceStyle {
        case .dark:
            layer.shadowOpacity = 0
        default:
            layer.shadowOpacity = 0.2
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
}
