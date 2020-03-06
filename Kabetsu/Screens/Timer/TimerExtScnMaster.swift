//
//  TimerExtScnMaster.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/02.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//



// **** DEPRECATED *****
// **** DEPRECATED *****
// **** DEPRECATED *****
// **** DEPRECATED *****



import UIKit

protocol TimerExtScnMasterDelegate: class {
    var task: TimerTask! { get set }
}

class TimerExtScnMaster: TimerVC {
    weak var delegate: TimerExtScnMasterDelegate!
    private lazy var dismissButton: UIButton! = configureDismissButton()
    
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
    private func configureViewController() {
        navigationController?.navigationItem.rightBarButtonItems = nil
    }
    @discardableResult private func configureDismissButton() -> UIButton {
        dismissButton = KBTDismissButton()
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
    
    func configureUniversalContraints() {
        let verticalEdgeInset: CGFloat = 20
        let horizontalEdgeInset: CGFloat = 5
        
        let digitDisplayVerticalInset: CGFloat = 130
        let digitDisplayHorizontalInset: CGFloat = 40
        let secondaryButtonsToPrimaryButtonPadding: CGFloat = 50
        
        let toolBarVerticalInset: CGFloat = 8
        let toolBarhorizontalInset: CGFloat = 90
        
        let layoutConstraints: [NSLayoutConstraint] = [
            dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            digitLabelsLayoutContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: digitDisplayVerticalInset),
            digitLabelsLayoutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: digitDisplayHorizontalInset),
            digitLabelsLayoutContainer.trailingAnchor.constraint(equalTo: secondaryButtonsContainer.trailingAnchor, constant: -digitDisplayHorizontalInset),
            digitLabelsLayoutContainer.bottomAnchor.constraint(equalTo: secondaryButtonsContainer.topAnchor),

            primaryButtonsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            primaryButtonsContainer.leadingAnchor.constraint(equalTo: secondaryButtonsContainer.trailingAnchor, constant: horizontalEdgeInset),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
    
            secondaryButtonsContainer.topAnchor.constraint(equalTo: view.centerYAnchor),
            secondaryButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secondaryButtonsContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: secondaryButtonsToPrimaryButtonPadding),
            secondaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
            
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 40),

            timerIncrementControl.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: toolBarVerticalInset),
            timerIncrementControl.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -toolBarVerticalInset),
            timerIncrementControl.leadingAnchor.constraint(greaterThanOrEqualTo: toolBar.leadingAnchor, constant: toolBarhorizontalInset),
            timerIncrementControl.trailingAnchor.constraint(lessThanOrEqualTo: toolBar.trailingAnchor, constant: -toolBarhorizontalInset),
            timerIncrementControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            timerIncrementControl.widthAnchor.constraint(equalToConstant: 800).withPriority(.defaultHigh)
        ]
        constraints.append(forSizeClass: .universal, constraints: layoutConstraints)
    }
    
//    override func configureIPadAndExternalDispayConstraints() {
//        let iPadConstraints: [NSLayoutConstraint] = [
//
//        ]
//
//        configureUniversalContraints()
//    }
    
}
