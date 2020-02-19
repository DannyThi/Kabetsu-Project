//
//  KBTBodyLabel.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit
#warning("FONT SCALE BY DEVICE (IPAD/IPHONE)")
class KBTBodyLabel: UILabel {
    
    init(text: String, fontSize: CGFloat? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.font = fontSize != nil ?
            UIFont.systemFont(ofSize: fontSize!, weight: .regular) : UIFont.preferredFont(forTextStyle: .body)
        configureLabel()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        textColor = .secondaryLabel
        textAlignment = .justified
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.001
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
