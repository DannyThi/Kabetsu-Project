//
//  KBTButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTButton: UIButton {

    init(withSFSymbolName symbolName: String, weight: UIImage.SymbolWeight? = nil) {
        super.init(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: 1000, weight: weight ?? .regular)
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        if image != nil { self.setImage(image, for: .normal) }
        backgroundColor = .systemGreen
        tintColor = .white
        configureButton()
    }
    init(withTitle title: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGreen
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel?.textColor = .white
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7
        translatesAutoresizingMaskIntoConstraints = false
        configureButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: VIEW LIFECYCLE

extension KBTButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateEdgeInsets()
        updateView(for: traitCollection.userInterfaceStyle)

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateView(for: traitCollection.userInterfaceStyle)
    }
    private func updateView(for userInterfaceStyle: UIUserInterfaceStyle) {
        let borderWidth = CGFloat.minimum(bounds.width, bounds.height) * 0.04
        switch userInterfaceStyle {
        case .dark:
            layer.borderWidth = borderWidth
            layer.shadowOpacity = 0
        default:
            layer.borderWidth = 0
            layer.shadowOpacity = 1
        }
    }
}

// MARK: CONFIGURATION

extension KBTButton {
    private func configureButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1.5
    }
    
    private func calculateEdgeInsets() {
        let multiplier: CGFloat = 0.20
        let horizontalEdgeInset = self.bounds.width * multiplier
        let verticalEdgeInset = self.bounds.height * multiplier
        
        self.imageEdgeInsets = UIEdgeInsets(top: verticalEdgeInset,
                                            left: horizontalEdgeInset,
                                            bottom: verticalEdgeInset,
                                            right: horizontalEdgeInset)
    }
}




