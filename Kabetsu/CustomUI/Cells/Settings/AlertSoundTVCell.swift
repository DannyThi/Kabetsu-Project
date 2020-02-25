//
//  AlertSoundTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/22.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol AlertSoundTVCellDelegate: class {
    func alertSoundTVCellTapped(_ sender: AlertSoundTVCell)
}

class AlertSoundTVCell: KBTSettingsBaseTVCell {
    static let reuseId = "alertSoundVCCell"
    
    private struct ImageKey {
        static let cellSymbol = "music.note"
        static let selected = "checkmark.circle"
    }
    
    var titleLabel: UILabel!
    var selectedIndicator: UIImageView!
    weak var delegate: AlertSoundTVCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureTitleLabel()
        configureSelectedIndicator()
        
        configureTitleLabelConstraints()
        configureSelectedIndicatorConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    func setSelected(animated: Bool) {
        guard animated else {
            self.selectedIndicator.alpha = 1
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.selectedIndicator.alpha = 1
        }
    }
    private func setDeselected(animated: Bool) {
        guard animated else {
            self.selectedIndicator.alpha = 0
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.selectedIndicator.alpha = 0
        }
    }

}


// MARK: ACTIONS

extension AlertSoundTVCell {
    @objc private func cellTapped() {
        guard let delegate = delegate else {
            print(KBTError.delegateNotSet("AlertSoundTVCell").formatted)
            return
        }
        delegate.alertSoundTVCellTapped(self)
    }
}


// MARK: CONFIGURATION

extension AlertSoundTVCell {
    private func configureCell() {
        let image = UIImage(systemName: ImageKey.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView.image = image
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(forName: .alertSoundSelected, object: nil, queue: nil) {
            [weak self] notification in
            guard let self = self else { return }
            guard self.titleLabel.text != notification.userInfo?["name"] as? String else { return }
            self.setDeselected(animated: true)
        }
    }
    private func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    private func configureSelectedIndicator() {
        let image = UIImage(systemName: ImageKey.selected, withConfiguration: GlobalImageKeys.symbolConfig())
        selectedIndicator = UIImageView(image: image)
        selectedIndicator.tintColor = .systemGreen
        selectedIndicator.translatesAutoresizingMaskIntoConstraints = false
        selectedIndicator.alpha = 0
        addSubview(selectedIndicator)
    }
}


// MARK: CONSTRAINTS

extension AlertSoundTVCell {
    private func configureTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.safeAreaLayoutGuide.trailingAnchor, constant: horizontalEdgeInset),
            titleLabel.trailingAnchor.constraint(equalTo: selectedIndicator.safeAreaLayoutGuide.leadingAnchor, constant: -horizontalEdgeInset),

        ])
    }
    private func configureSelectedIndicatorConstraints() {
        NSLayoutConstraint.activate([
            selectedIndicator.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: symbolImageInset.top),
            selectedIndicator.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -symbolImageInset.bottom),
            selectedIndicator.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            selectedIndicator.widthAnchor.constraint(equalTo: selectedIndicator.heightAnchor)
        ])
    }
}
