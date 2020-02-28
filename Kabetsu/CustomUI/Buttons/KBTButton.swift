//
//  KBTButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTButton: UIButton {
    
    var imageConfig: UIImage.SymbolConfiguration?
    
    override var bounds: CGRect {
        didSet {
            calculateImageEdgeInsets()
            calculateCornerRadius()
            calculateTitleEdgeInsets()
            updateView(for: traitCollection.userInterfaceStyle)
            applyGradient()
        }
    }

    init(withSFSymbolName symbolName: String, weight: UIImage.SymbolWeight? = nil) {
        super.init(frame: .zero)
        self.imageConfig = UIImage.SymbolConfiguration(pointSize: 1000, weight: weight ?? .regular)
        let image = UIImage(systemName: symbolName, withConfiguration: imageConfig)
        if image != nil { self.setImage(image, for: .normal) }
        configureButton()
    }
    init(withTitle title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 1000, weight: .bold)
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.textAlignment = .center
        titleLabel?.baselineAdjustment = .alignCenters
        titleLabel?.adjustsFontSizeToFitWidth = true
        configureButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSymbolImage(symbolName: String) {
        if imageConfig != nil {
            imageConfig = UIImage.SymbolConfiguration(pointSize: 1000, weight: .regular)
        }
        let image = UIImage(systemName: symbolName, withConfiguration: imageConfig)
        setImage(image, for: .normal)
    }
}

// MARK: VIEW LIFECYCLE

extension KBTButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateView(for: traitCollection.userInterfaceStyle)
        applyGradient()
    }
    
    private func updateView(for userInterfaceStyle: UIUserInterfaceStyle) {
        let borderWidth = CGFloat.minimum(bounds.width, bounds.height) * 0.03
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
        //self.backgroundColor = .systemGreen
        self.tintColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 1.5
    }
    private func calculateImageEdgeInsets() {
        let multiplier: CGFloat = 0.2
        let horizontalEdgeInset = self.bounds.width * multiplier
        let verticalEdgeInset = self.bounds.height * multiplier
        self.imageEdgeInsets = UIEdgeInsets(top: verticalEdgeInset,
                                            left: horizontalEdgeInset,
                                            bottom: verticalEdgeInset,
                                            right: horizontalEdgeInset)
    }
    private func calculateTitleEdgeInsets() {
        let multiplier: CGFloat = 0.05
        let horizontalEdgeInset = self.bounds.width * multiplier
        let verticalEdgeInset = self.bounds.height * multiplier
        self.titleEdgeInsets = UIEdgeInsets(top: verticalEdgeInset,
                                            left: horizontalEdgeInset,
                                            bottom: verticalEdgeInset,
                                            right: horizontalEdgeInset)
    }
    private func calculateCornerRadius() {
        let cornerRadius = CGFloat.minimum(bounds.width, bounds.height) * 0.3
        self.layer.cornerRadius = cornerRadius
    }
    private func applyGradient() {
        self.applyGradient(colours: Constants.Gradient.green)
    }
}




