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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        layer.cornerRadius = bounds.width / 2
    }
}
