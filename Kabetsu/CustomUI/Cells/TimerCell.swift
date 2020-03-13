//
//  TimerCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Spawn Camping Panda. All rights reserved.
//

import UIKit

protocol TimerCellDelegate: class {
    func didTapDeleteButton(identifier: Any)
}

class TimerCell: UICollectionViewCell {
    
    static let reuseId = "CountdownTimerCell"
    
    private struct ImageKeys {
        static let remove = "trash.circle.fill"
    }

    private var countdownLabel: KBTDigitDisplayLabel!
    private var removeButton = UIButton()
    
    private var identifier: TimeInterval!
    weak var delegate: TimerCellDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureLabel()
        configureRemoveButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(timeInterval: TimeInterval, delegate: TimerCellDelegate) {
        countdownLabel.setTime(usingRawTime: timeInterval)
        self.identifier = timeInterval
        self.delegate = delegate
    }
}


// MARK: TRAIT COLLECTION

extension TimerCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateViewAppearance()
    }
    private func updateViewAppearance() {
        contentView.layer.borderWidth = scaledBorderWidth(strength: Constants.ViewAppearance.borderWidth)
        layer.shadowOpacity = Constants.ViewAppearance.shadowOpacity
    }
}


// MARK: - CONFIGURATION

extension TimerCell {
    
    private func configureCell() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 25
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = scaledBorderWidth(strength: Constants.ViewAppearance.borderWidth)
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = Constants.ViewAppearance.shadowOpacity
        layer.masksToBounds = false
    }
    
    private func configureLabel() {
        countdownLabel = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .center)
        countdownLabel.textColor = .label
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
            countdownLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countdownLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countdownLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            countdownLabel.heightAnchor.constraint(equalTo: countdownLabel.widthAnchor, multiplier: Constants.ViewAppearance.digitalDisplayFontHeightToWidthRatio)
        ])
    }
    
    private func configureRemoveButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        
        let removeImage = UIImage(systemName: ImageKeys.remove, withConfiguration: config)!
        removeButton.setImage(removeImage, for: .normal)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(removeButton)
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
        removeButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        guard let delegate = delegate else {
            print(KBTError.delegateNotSet("TimerCell").formatted)
            return
        }
        delegate.didTapDeleteButton(identifier: identifier!)
    }
}

