//
//  InterfaceStyleTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/14.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol InterfaceStyleTVCellDelegate {
    func interfaceFollowsIOSSwitchValueChanged(_ value: Bool)
}

class InterfaceStyleTVCell: UITableViewCell {
    static let reuseId = "userStyleTableViewCell"
    
    private struct ImageKeys {
        static let cellSymbol = "circle.lefthalf.fill"
    }
    
    private var symbolImageView: UIImageView!
    private var titleLabel: UILabel!
    private var interfaceFollowsIOSSwitch: UISwitch!
    
    var delegate: InterfaceStyleTVCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSymbolImageView()
        configureTitleLabel()
        configureInterfaceFollowsIOSSwitch()
        configureSymbolImageViewConstraints()
        configureTitleLabelConstraints()
        configureInterfaceFollowsIOSSwitchConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(interfaceStyleFollowsIOS value: Bool) {
        interfaceFollowsIOSSwitch.setOn(value, animated: false)
    }
}



// MARK: - Actions

extension InterfaceStyleTVCell {
    @objc private func interfaceFollowsIOSSwitchTapped(_ sender: UISwitch) {
        guard let delegate = delegate else {
            print("Delegate has not been set for InterfaceStyleTVCell.interfaceFollowsIOSSwitchTapped(_:)")
            return
        }
        delegate.interfaceFollowsIOSSwitchValueChanged(sender.isOn)
    }
}

// MARK: - Configuration

extension InterfaceStyleTVCell {
    private func configureSymbolImageView() {
        let image = UIImage(systemName: ImageKeys.cellSymbol , withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView = UIImageView(image: image)
        symbolImageView.tintColor = .systemGreen
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
    }
    private func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Follows iOS settings"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    private func configureInterfaceFollowsIOSSwitch() {
        interfaceFollowsIOSSwitch = UISwitch()
        interfaceFollowsIOSSwitch.translatesAutoresizingMaskIntoConstraints = false
        interfaceFollowsIOSSwitch.addTarget(self, action: #selector(interfaceFollowsIOSSwitchTapped), for: .valueChanged)
        addSubview(interfaceFollowsIOSSwitch)
    }
}



// MARK: - Constraints

extension InterfaceStyleTVCell {
    private var verticalPadding: CGFloat { return 8 }
    private var horizontalPadding: CGFloat { return 20 }
    
    private func configureSymbolImageViewConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),
            symbolImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding)
        ])
    }
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
        ])
    }
    private func configureInterfaceFollowsIOSSwitchConstraints() {
        NSLayoutConstraint.activate([
            interfaceFollowsIOSSwitch.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            interfaceFollowsIOSSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            interfaceFollowsIOSSwitch.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding)
        ])
    }
}
