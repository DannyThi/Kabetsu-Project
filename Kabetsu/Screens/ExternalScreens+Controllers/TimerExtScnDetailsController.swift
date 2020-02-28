//
//  TimerExtScnDetailsController.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/21.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol TimerExtScnDetailsControllerDelegate: class {
    var task: TimerTask! { get }
}

class TimerExtScnDetailsController: UIViewController {

    private var digitalDisplayLabel: KBTDigitDisplayLabel!
    private var secondaryDigitalDisplaylabel: KBTDigitDisplayLabel!
    private var alert: KBTAlertController?
    
    weak var delegate: TimerExtScnDetailsControllerDelegate!

}

// MARK: VIEW CONTROLLER LIFECYCLE

extension TimerExtScnDetailsController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNotifications()
        configureDigitalDisplayLabel()
        configureSecondaryDigitalDisplayLabel()
        
        configureConstraints()
        
        configureExternalScreen()
    }
}

// MARK: ACTIONS

extension TimerExtScnDetailsController {
    private func updateDigitalDisplayLabel() {
        guard let delegate = delegate else { print(KBTError.delegateNotSet("TimerDisplayVC").formatted); return }
        digitalDisplayLabel.setTime(usingRawTime: delegate.task.currentCountdownTime, usingMilliseconds: true)
    }
    func updateSecondaryDigitalDisplayLabel() {
        guard let delegate = delegate else { print(KBTError.delegateNotSet("TimerDisplayVC").formatted); return }
        secondaryDigitalDisplaylabel.setTime(usingRawTime: delegate.task.adjustedCountdownTime, usingMilliseconds: true)
    }
    
    private func handleTimerDidEnd() {
        guard alert == nil else { return }
        let alert = KBTAlertController(withTitle: "TIME UP!")
        self.alert = alert
        self.present(alert, animated: true)
    }
    private func dismissAlert() {
        alert?.dismiss(animated: true)
        alert = nil
    }
}


// MARK: CONFIGURATION

extension TimerExtScnDetailsController {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    private func configureNotifications() {
        NotificationCenter.default.addObserver(forName: .timerDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.updateDigitalDisplayLabel()
        }
        NotificationCenter.default.addObserver(forName: .alertDidDismiss, object: nil, queue: .main) { [weak self] _ in
            self?.dismissAlert()
        }
    }
    private func configureDigitalDisplayLabel() {
        digitalDisplayLabel = KBTDigitDisplayLabel(withFontSize: 500, fontWeight: .bold, textAlignment: .center)
        updateDigitalDisplayLabel()
        view.addSubview(digitalDisplayLabel)
    }
    private func configureSecondaryDigitalDisplayLabel() {
        secondaryDigitalDisplaylabel = KBTDigitDisplayLabel(withFontSize: 400, fontWeight: .bold, textAlignment: .center)
        secondaryDigitalDisplaylabel.textColor = .tertiaryLabel
        updateSecondaryDigitalDisplayLabel()
        view.addSubview(secondaryDigitalDisplaylabel)
    }
    
    
    
    private func configureExternalScreen() {
        
    }
}

// MARK: CONSTRAINTS

extension TimerExtScnDetailsController {
    private func configureConstraints() {
        let verticalOffset: CGFloat = 60
        
        NSLayoutConstraint.activate([
            digitalDisplayLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -verticalOffset),
            digitalDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitalDisplayLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            digitalDisplayLabel.heightAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor, constant: 10),
            secondaryDigitalDisplaylabel.widthAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: 0.5),
            secondaryDigitalDisplaylabel.centerXAnchor.constraint(equalTo: digitalDisplayLabel.centerXAnchor),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitalDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
        ])
    }
}
