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
        
        updateTimeDisplayLabels()
        updateActionButtonImage()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .landscape : .all
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
    override func configureIPhoneLandscapeRegularConstraints() {
        super.configureIPhoneLandscapeRegularConstraints()
        
        let layoutConstraints: [NSLayoutConstraint] = [
            dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ]
        
        constraints.append(forSizeClass: .iPhoneLandscapeRegular, constraints: layoutConstraints)
    }
}
