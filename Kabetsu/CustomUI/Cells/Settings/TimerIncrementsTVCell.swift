//
//  TimerIncrementsTVCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/16.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol TimerIncrementsTVCellDelegate: class {
    func timerIncrementsSegmentControlValueChanged(value: Int)
}

class TimerIncrementsTVCell: KBTSettingsBaseTVCell {
    static let reuseId = "timerIncrementsTVCell"
    
    private struct ImageKey {
        static let cellSymbol = "timer"
    }
    
    private var timerIncrementSegmentControl: UISegmentedControl!
    weak var delegate: TimerIncrementsTVCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureTimerIncrementSegmentControl()
        configureTimerIncrementsSegmentedControlConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(timeIncrements: [TimeInterval], selectedIndex: Int) {
        if timerIncrementSegmentControl.numberOfSegments == 0 {
            for (index, time) in timeIncrements.enumerated() {
                self.timerIncrementSegmentControl.insertSegment(withTitle: "\(Int(time))s", at: index, animated: false)
            }
        }
        timerIncrementSegmentControl.selectedSegmentIndex = selectedIndex
    }
}


// MARK: - ACTIONS

extension TimerIncrementsTVCell {
    @objc private func timerIncrementsSegmentControlValueChanged(_ sender: UISegmentedControl) {
        guard let delegate = delegate else {
            print(KBTError.delegateNotSet("TimerIncrementsTVCell").formatted)
            return
        }
        delegate.timerIncrementsSegmentControlValueChanged(value: timerIncrementSegmentControl.selectedSegmentIndex)
    }
}


// MARK: - CONFIGURATION

extension TimerIncrementsTVCell {
    private func configureCell() {
        let image = UIImage(systemName: ImageKey.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView.image = image
    }
    private func configureTimerIncrementSegmentControl() {
        timerIncrementSegmentControl = UISegmentedControl()
        timerIncrementSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        timerIncrementSegmentControl.addTarget(self, action: #selector(timerIncrementsSegmentControlValueChanged(_:)), for: .valueChanged)
        addSubview(timerIncrementSegmentControl)
    }
    
}


// MARK: - CONSTRAINTS

extension TimerIncrementsTVCell {
    private func configureTimerIncrementsSegmentedControlConstraints() {
        NSLayoutConstraint.activate([
            timerIncrementSegmentControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            timerIncrementSegmentControl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
            timerIncrementSegmentControl.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: horizontalEdgeInset),
            timerIncrementSegmentControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
        ])
    }
}
