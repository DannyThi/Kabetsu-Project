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

    private var countdownLabel: KBTDigitalDisplayLabel!
    private var removeButton = UIButton()
    
    private var identifier: TimeInterval!
    weak var delegate: TimerCellDelegate!
    
    // MARK: - Initialization
    
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


// MARK: - Configuration & Setup

extension TimerCell {
    
    private func configureCell() {
        contentView.backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        clipsToBounds = true
    }
    
    private func configureLabel() {
        countdownLabel = KBTDigitalDisplayLabel(withFontSize: 30, fontWeight: .bold, textAlignment: .center)
        countdownLabel.textColor = .label
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countdownLabel)
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            countdownLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countdownLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            countdownLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            countdownLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureRemoveButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        
        let removeImage = UIImage(systemName: "trash.circle.fill", withConfiguration: config)!
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
            print("No delegate set for cell.")
            return
        }
        delegate.didTapDeleteButton(identifier: identifier!)
    }
}

