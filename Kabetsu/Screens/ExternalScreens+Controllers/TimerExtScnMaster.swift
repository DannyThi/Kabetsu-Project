//
//  TimerExtScnMaster.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/02.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol TimerExtScnMasterDelegate: class {
    var task: TimerTask! { get set }
}

class TimerExtScnMaster: TimerVC, TimerExtScnDetailsControllerDelegate {
    weak var delegate: TimerExtScnMasterDelegate!
    private lazy var dismissButton: KBTButton! = configureDismissButton()
}


// MARK: ACTIONS

extension TimerExtScnMaster {
    override func dismissController() {
        externalDisplay.endProjecting()
        dismiss(animated: true)
    }
}

// MARK: VIEW CONTROLLER LIFECYCLE

extension TimerExtScnMaster {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailsView()
        configureUniversalContraints()
        updateTimeDisplayLabels()
        updateActionButtonImage()
        
        constraints.activate(.universal)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .landscape : .all
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        constraints.activate(.universal)
    }
}

// MARK: CONFIGURATION

extension TimerExtScnMaster {
    @discardableResult private func configureDismissButton() -> KBTButton {
        dismissButton = KBTCircularButton(withSFSymbolName: GlobalImageKeys.dismiss.rawValue)
        dismissButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        view.addSubview(dismissButton)
        return dismissButton
    }
    private func configureDetailsView() {
        if externalDisplay.rootViewController == nil {
            let detailsView = TimerExtScnDetails()
            detailsView.delegate = self
            externalDisplay.project(detailsViewController: detailsView)
            if let delegate = delegate {
                self.task = delegate.task
            } else {
                print(KBTError.delegateNotSet("TimerExtScnMaster").formatted)
            }
        }
    }
}

// MARK: CONSTRAINTS

extension TimerExtScnMaster {
    
    #warning("RELAYOUT UI")
    func configureUniversalContraints() {
        let verticalPadding: CGFloat = 20
        let horizontalPadding: CGFloat = 50
        let toolBarVerticalPadding: CGFloat = 8
        
        let layoutConstraints: [NSLayoutConstraint] = [
            dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            
            digitDisplayLabel.widthAnchor.constraint(equalTo: buttonContainer.widthAnchor),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            digitDisplayLabel.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            digitDisplayLabel.bottomAnchor.constraint(equalTo: secondaryDigitDisplaylabel.topAnchor),
            
            secondaryDigitDisplaylabel.widthAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: 0.8),
            secondaryDigitDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            secondaryDigitDisplaylabel.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -50),
            secondaryDigitDisplaylabel.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            
            primaryActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200),
            primaryActionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).withPriority(.defaultHigh),
            primaryActionButton.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalPadding),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetButton.heightAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 75),
        
            buttonContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalPadding),
            buttonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            timerIncrementControl.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: toolBarVerticalPadding),
            timerIncrementControl.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -toolBarVerticalPadding),
            timerIncrementControl.leadingAnchor.constraint(greaterThanOrEqualTo: toolBar.leadingAnchor, constant: horizontalPadding),
            timerIncrementControl.trailingAnchor.constraint(lessThanOrEqualTo: toolBar.trailingAnchor, constant: -horizontalPadding),
            timerIncrementControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            timerIncrementControl.widthAnchor.constraint(equalToConstant: 800).withPriority(.defaultHigh)
        ]
        
        constraints.append(forSizeClass: .universal, constraints: layoutConstraints)
    }
    
    override func configureIPadAndExternalDispayConstraints() {
        
    }
    
}
