//
//  KBTSymbolImageView.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/16.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit
#warning("TODO or REMOVE")
class KBTSymbolImageView: UIImageView {
    
    init(withSymbol: String) {
        super.init(frame: .zero)
        configureImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        self.tintColor = .systemGreen
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    
}
