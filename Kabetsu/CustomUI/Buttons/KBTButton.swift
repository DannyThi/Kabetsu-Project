//
//  KBTButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTButton: UIButton {
    
    init(withSFSymbolName symbolName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight? = nil) {
        super.init(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight ?? .regular)
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        if image != nil { self.setImage(image, for: .normal) }
        configureButton()
        updateView(for: traitCollection.userInterfaceStyle)
    }
    init(withTitle title: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGreen
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel?.textColor = .secondaryLabel
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7
        translatesAutoresizingMaskIntoConstraints = false
        configureButton()
        updateView(for: traitCollection.userInterfaceStyle)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        updateView(for: traitCollection.userInterfaceStyle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
    }
    
    private func updateView(for userInterfaceStyle: UIUserInterfaceStyle) {
        switch userInterfaceStyle {
        case .dark:
            layer.borderWidth = 2
            layer.shadowOpacity = 0
        default:
            layer.borderWidth = 0
            layer.shadowOpacity = 0.5
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateView(for: traitCollection.userInterfaceStyle)
    }
    
    
}


