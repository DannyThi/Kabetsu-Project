//
//  AlertSoundTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/22.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol AlertSoundTVCellDelegate: class {
    func alertSoundPickerValueChanged(value: Int)
}

class AlertSoundTVCell: UITableViewCell {
    static let reuseId = "alertSoundVCCell"
    
    private struct ImageKey {
        static let cellSymbol = "music.note"
    }
    private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }

}

// MARK: CONFIGURATION

extension AlertSoundTVCell {
    private func configureCell() {
        
    }
    private func configureTitleLabel() {
        
    }
}
