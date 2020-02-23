//
//  AlertSoundVolumeTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/23.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol AlertVolumeTVCellDelegate: class {
    func volumeSliderValueChanged(_ value: Double)
}

class AlertVolumeTVCell: KBTSettingsBaseTVCell {
    static let reuseId = "alertVolumeTVCell"
    
    private struct ImageKey {
        static let cellSymbol = "speaker.3"
        static let soundMute = "speaker.fill"
        static let soundFull = "speaker.3.fill"
    }
    
    private var soundMuteImageView: UIImageView!
    private var soundFullImageView: UIImageView!
    private var volumeSlider: UISlider!
    
    weak var delegate: AlertVolumeTVCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureVolumeSlider()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(volume: Double) {
        self.volumeSlider.setValue(Float(volume), animated: false)
    }
}


// MARK: ACTIONS

extension AlertVolumeTVCell {
    @objc private func volumeSliderValueChanged(_ sender: UISlider) {
        guard let delegate = delegate else {
            print(KBTError.delegateNotSet("AlertVolumeControlTVCell").formatted)
            return
        }
        delegate.volumeSliderValueChanged(Double(sender.value))
    }
}


// MARK: CONFIGURATION

extension AlertVolumeTVCell {
    private func configureCell() {
        let image = UIImage(systemName: ImageKey.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView.image = image
    }
    private func configureVolumeSlider() {
        let minImage = UIImage(systemName: ImageKey.soundMute, withConfiguration: GlobalImageKeys.symbolConfig(pointSize: 15))
        let maxImage = UIImage(systemName: ImageKey.soundFull, withConfiguration: GlobalImageKeys.symbolConfig(pointSize: 15))
        volumeSlider = UISlider()
        volumeSlider.tintColor = .systemGreen
        volumeSlider.isContinuous = false
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.minimumValueImage = minImage
        volumeSlider.maximumValueImage = maxImage
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.addTarget(self, action: #selector(volumeSliderValueChanged(_:)), for: .valueChanged)
        addSubview(volumeSlider)
    }
}


// MARK: CONSTRAINTS

extension AlertVolumeTVCell {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            volumeSlider.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
            volumeSlider.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: horizontalEdgeInset),
            volumeSlider.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
        ])
    }
}
