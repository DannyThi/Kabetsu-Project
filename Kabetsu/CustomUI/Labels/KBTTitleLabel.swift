//
//  KBTTitleLabel.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTTitleLabel: UILabel {
    
    init(textAlignment: NSTextAlignment, fixedFontSize fontSize: CGFloat? = nil) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize ?? 300, weight: .black)
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
        textColor = .label
        baselineAdjustment = .alignCenters
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.001
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
