//
//  StopwatchExtScnDetails.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/06.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol StopwatchExtScnDetailsDelegate {
    var stopwatch: Stopwatch! { get set }
}

class StopwatchExtScnDetails: UIViewController {
    
    private var digitDisplayLabel: KBTDigitDisplayLabel!
    var delegate: StopwatchExtScnDetailsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDigitDisplay()
        configureNotificationsListeners()
    }
    
    private func updateUI() {
        digitDisplayLabel.setTime(usingRawTime: delegate.stopwatch.elapsedTime, usingMilliseconds: true)
    }
}

// MARK: CONFIGURATION

extension StopwatchExtScnDetails {
    
    private func configureDigitDisplay() {
        digitDisplayLabel = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .center)
        digitDisplayLabel.font = UIFont(name: "HelveticaNeue-medium", size: 1000)
        digitDisplayLabel.textColor = KBTColors.primaryLabel
        digitDisplayLabel.setTime(usingRawTime: delegate.stopwatch.elapsedTime, usingMilliseconds: true)
        view.addSubview(digitDisplayLabel)
        NSLayoutConstraint.activate([
            digitDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitDisplayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            digitDisplayLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor,
                                                      multiplier: Constants.ViewAppearance.digitalDisplayFontHeightToWidthRatio)
        ])
    }
    private func configureNotificationsListeners() {
        NotificationCenter.default.addObserver(forName: .stopwatchDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.updateUI()
        }
    }
}
