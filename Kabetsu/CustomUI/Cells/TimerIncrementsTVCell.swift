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

class TimerIncrementsTVCell: UITableViewCell {
    static let reuseId = "timerIncrementsTVCell"
    
    private struct ImageKeys {
        static let cellSymbol = "timer"
    }
    
    private var symbolImageView: UIImageView!
    private var timerIncrementSegmentControl: UISegmentedControl!
    
    weak var delegate: TimerIncrementsTVCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
        configureSymbolImageView()
        configureTimerIncrementSegmentControl()
        
        configureSymbolImageViewConstraints()
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
    private func configureTableViewCell() {

    }
    private func configureSymbolImageView() {
        let image = UIImage(systemName: ImageKeys.cellSymbol, withConfiguration: GlobalImageKeys.symbolConfig())
        symbolImageView = UIImageView(image: image)
        symbolImageView.tintColor = .systemGreen
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
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
    private var verticalPadding: CGFloat { return 8 }
    private var horizontalPadding: CGFloat { return 20 }
    private var horizontalPaddingIndented: CGFloat { return 50 }
    
    private func configureSymbolImageViewConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            symbolImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            symbolImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            symbolImageView.widthAnchor.constraint(equalTo: symbolImageView.heightAnchor),
        ])
    }
    private func configureTimerIncrementsSegmentedControlConstraints() {
        NSLayoutConstraint.activate([
            timerIncrementSegmentControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            timerIncrementSegmentControl.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            timerIncrementSegmentControl.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 8),
            timerIncrementSegmentControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
}
