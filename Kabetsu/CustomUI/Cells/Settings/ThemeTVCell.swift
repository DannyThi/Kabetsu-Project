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

class ThemeTVCell: KBTSettingsBaseTVCell {
    static let reuseId = "themeTVCell"
    
    struct ImageKey {
        static let cellSymbol = "chevron.right.2"
    }
    
    override var symbolImageInset: UIEdgeInsets { return UIEdgeInsets(top: 16, left: 40, bottom: 16, right: 0) }
    private var themeSegmentControl: UISegmentedControl!
    weak var delegate: ThemeTVCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureThemeSegementControl()
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
            print(KBTError.delegateNotSet("ThemeTVCell").formatted)
            return
        }
        delegate.themeSegmentControlValueChanged(selectedIndex)
    }
}



// MARK: - CONFIGURATION

extension ThemeTVCell {
    private func configureCell() {
        let image = UIImage(systemName: ImageKey.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView.image = image
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
    private func configureThemeSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            themeSegmentControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            themeSegmentControl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
            themeSegmentControl.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 8),
            themeSegmentControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
        ])
    }
}
