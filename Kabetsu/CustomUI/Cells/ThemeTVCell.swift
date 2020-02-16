//
//  ThemeTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/16.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class ThemeTVCell: UITableViewCell {
    static let reuseId = "themeTVCell"
    
    private struct ImageKeys {
        static let cellSymbol = "circle.lefthalf.fill"
    }
    
    private var symbolImageView: UIImageView!
    private var themSegmentControl: UISegmentedControl!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - CONFIGURATION



// MARK: - CONSTRAINTS
