//
//  KBTCircularButton.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/30.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTCircularButton: KBTButton {
    override init(withSFSymbolName symbolName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight? = nil) {
        super.init(withSFSymbolName: symbolName, pointSize: pointSize, weight: weight)
        configure()
    }
    
    override init(withTitle title: String) {
        super.init(withTitle: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
