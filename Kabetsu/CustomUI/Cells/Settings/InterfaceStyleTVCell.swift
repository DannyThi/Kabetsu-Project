//
//  InterfaceStyleTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/14.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol InterfaceStyleTVCellDelegate: class {
    func interfaceFollowsIOSSwitchValueChanged(_ value: Bool)
}

class InterfaceStyleTVCell: KBTSettingsBaseTVCell {
    static let reuseId = "userStyleTableViewCell"
    
    struct ImageKey {
        static let cellSymbol = "circle.lefthalf.fill"
    }
    
    private var titleLabel: UILabel!
    private var interfaceFollowsIOSSwitch: UISwitch!
    
    weak var delegate: InterfaceStyleTVCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureTitleLabel()
        configureInterfaceFollowsIOSSwitch()
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



// MARK: - ACTIONS

extension InterfaceStyleTVCell {
    @objc private func interfaceFollowsIOSSwitchTapped(_ sender: UISwitch) {
        guard let delegate = delegate else {
            print(KBTError.delegateNotSet("InterfaceStyleTVCell").formatted)
            return
        }
        delegate.interfaceFollowsIOSSwitchValueChanged(sender.isOn)
    }
}


// MARK: - CONFIGURATION

extension InterfaceStyleTVCell {
    private func configureCell() {
        let image = UIImage(systemName: ImageKey.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView.image = image
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


// MARK: - CONSTRAINTS

extension InterfaceStyleTVCell {
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: horizontalEdgeInset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
        ])
    }
    private func configureInterfaceFollowsIOSSwitchConstraints() {
        NSLayoutConstraint.activate([
            interfaceFollowsIOSSwitch.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            interfaceFollowsIOSSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalEdgeInset),
            interfaceFollowsIOSSwitch.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset)
        ])
    }
}
