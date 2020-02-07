//
//  KBTButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit



class KBTButton: UIButton {
    
    public init(withSFSymbolName symbolName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight? = nil) {
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight ?? .regular)
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        if image != nil {
            self.setImage(image, for: .normal)
        }
        configure()
    }
    
    public init(withTitle title: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGreen
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel?.textColor = .secondaryLabel
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7

        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}


