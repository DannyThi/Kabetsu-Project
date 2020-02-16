//
//  TimerIncrementsTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/16.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerIncrementsTVCell: UITableViewCell {
    static let reuseId = "timerIncrementsTVCell"
    
    private struct ImageKeys {
        static let cellSymbol = "timer"
    }
    
    private var symbolImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
        configureSymbolImageView()
        
        configureSymbolImageViewConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - ACTIONS

extension TimerIncrementsTVCell {
    
}



// MARK: - CONFIGURATION

extension TimerIncrementsTVCell {
    private func configureTableViewCell() {

    }
    private func configureSymbolImageView() {
        let image = UIImage(systemName: ImageKeys.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView = UIImageView(image: image)
        symbolImageView.tintColor = .systemGreen
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
    }
    
}



// MARK: - CONSTRAINTS

extension TimerIncrementsTVCell {
    private var verticalPadding: CGFloat { return 8 }
    private var horizontalPadding: CGFloat { return 20 }
    private var horizontalPaddingIndented: CGFloat { return 50 }
    
    private func configureSymbolImageViewConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            symbolImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),
        ])
    }
    
}
