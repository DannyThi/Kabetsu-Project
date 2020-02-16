//
//  ThemeTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/16.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol ThemeTVCellDelegate: class {
    func themeSegmentControlValueChanged(_ segmentIndex: Int)
}

class ThemeTVCell: UITableViewCell {
    static let reuseId = "themeTVCell"
    
    private struct ImageKeys {
        static let cellSymbol = "chevron.right.2"
    }
    
    private var symbolImageView: UIImageView!
    private var themeSegmentControl: UISegmentedControl!
    weak var delegate: ThemeTVCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSymbolImageView()
        configureThemeSegementControl()
        
        configureSymbolImageViewConstraints()
        configureThemeSegmentControlConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(selectedSegmentIndex index: Int) {
        themeSegmentControl.selectedSegmentIndex = index
    }
}



// MARK: - ACTIONS

extension ThemeTVCell {
    @objc private func themeSegmentControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard let delegate = delegate else {
            print("Delegate not set for ThemeTVCell.themeSegmentControl.")
            return
        }
        delegate.themeSegmentControlValueChanged(selectedIndex)
    }
}



// MARK: - CONFIGURATION

extension ThemeTVCell {
    private func configureSymbolImageView() {
        let image = UIImage(systemName: ImageKeys.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView = UIImageView(image: image)
        symbolImageView.tintColor = .systemGreen
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
    }
    private func configureThemeSegementControl() {
        themeSegmentControl = UISegmentedControl(items: InterfaceStyle.allCases.map { $0.title } )
        themeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        themeSegmentControl.addTarget(self, action: #selector(themeSegmentControlValueChanged), for: .valueChanged)
        addSubview(themeSegmentControl)
    }
}

// MARK: - CONSTRAINTS

extension ThemeTVCell {
    private var verticalPadding: CGFloat { return 8 }
    private var horizontalPadding: CGFloat { return 20 }
    private var horizontalPaddingIndented: CGFloat { return 50 }
    
    private func configureSymbolImageViewConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding * 2),
            symbolImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding * 2),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPaddingIndented),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),
        ])
    }
    
    private func configureThemeSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            themeSegmentControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            themeSegmentControl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            themeSegmentControl.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 8),
            themeSegmentControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
}
