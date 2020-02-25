//
//  KBTSettingsBaseTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/23.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTSettingsBaseTVCell: UITableViewCell {
    
    var symbolImageView: UIImageView!
    var symbolImageInset: UIEdgeInsets { return UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20) }
    var verticalEdgeInset: CGFloat { return 12 }
    var horizontalEdgeInset: CGFloat { return 20 }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSymbolImageView()
        configureSymbolImageViewConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSymbolImageView() {
        symbolImageView = UIImageView()
        symbolImageView.tintColor = .systemGreen
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
    }
    func configureSymbolImageViewConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: symbolImageInset.top),
            symbolImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -symbolImageInset.bottom),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: symbolImageInset.left),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),
        ])
    }
}



class VibrateOnAlertCVCell: KBTSettingsBaseTVCell {
    
    static let reuseId = "vibrateOnAlertCVCell"
    
    private var titleLabel: KBTTitleLabel!
    private var actionSwitch: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
