//
//  TimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, TimerExtScnDetailsControllerDelegate {
        
    var task: TimerTask!
    private let externalDisplay = ExternalDisplayManager.shared
    private var constraints = KBTConstraints()
    private let settings = Settings.shared
    private var projectButton: UIBarButtonItem!
    
    private var digitDisplayLabel: KBTDigitDisplayLabel!
    private var secondaryDigitDisplaylabel: KBTDigitDisplayLabel!
    
    private var primaryActionButton: KBTCircularButton!
    private var decrementButton: KBTButton!
    private var incrementButton: KBTButton!
    private var resetButton: KBTButton!
    private var buttonContainer: UIStackView!
    
    private var toolBar: UIToolbar!
    private var timerIncrementControl: UISegmentedControl!
    
//    private var buttonImagePointSize: CGFloat = 80

    private struct ImageKeys {
        static let play = "play"
        static let pause = "pause"
        static let reset = "arrow.counterclockwise"
    }
    
    init(withTask task: TimerTask) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
        hidesBottomBarWhenPushed = true
        modalTransitionStyle = .flipHorizontal
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - TIMER STATE

extension TimerVC {

    private func reset() {
        task = TimerTask(withTotalTime: task.originalCountdownTime)
        updateTimeDisplayLabels()
        updateTitle()
        updateActionButtonImage()
    }
}



// MARK: - UI UPDATES

extension TimerVC {
    private func updateTitle() {
        let style = view.bounds.width > 500 ? DateComponentsFormatter.UnitsStyle.full : DateComponentsFormatter.UnitsStyle.short
        self.title = TimerTask.formattedTimeFrom(timeInterval: self.task.adjustedCountdownTime, style: style)
    }
    private func updateTimeDisplayLabels() {
        digitDisplayLabel.setTime(usingRawTime: task.currentCountdownTime, usingMilliseconds: true)
        secondaryDigitDisplaylabel.setTime(usingRawTime: task.adjustedCountdownTime, usingMilliseconds: true)
    }
    private func updateActionButtonImage() {
        var imageString = ""
        switch task.timerState {
        case .running:
            imageString = ImageKeys.pause
        case .paused, .initialized:
            imageString = ImageKeys.play
        case .ended:
            imageString = ImageKeys.reset
        }
        primaryActionButton.updateSymbolImage(symbolName: imageString)
    }
    private func updateButtonLabels(timeInterval: Double) {
        decrementButton.setTitle("-\(Int(timeInterval))s", for: .normal)
        incrementButton.setTitle("+\(Int(timeInterval))s", for: .normal)
    }
    private func updateConstraints() {
        if (traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular) ||
            (traitCollection.verticalSizeClass == .unspecified && traitCollection.horizontalSizeClass == .unspecified) {
            constraints.activate(.iPadAndExternalDisplays)
            return
        }
        if traitCollection.verticalSizeClass == .compact {
            constraints.activate(.iPhoneLandscapeRegular)
            return
        }
        constraints.activate(.iPhonePortrait)
    }
    private func updateProjectButtonStatus() {
        projectButton.isEnabled =  UIScreen.screens.count > 1 ? true : false
    }
}



// MARK: - ACTIONS

extension TimerVC {
    @objc private func dismissController() {
        if task.timerState != .initialized {
            let ac = UIAlertController(title: "Timer is running.",
                                       message: "Your timer is still running. Exit anyway?",
                                       preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
                self?.externalDisplay.endProjecting()
                self?.dismiss(animated: true)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            ac.addAction(cancel)
            ac.addAction(ok)
            present(ac, animated: true)
        } else {
            //externalDisplay.endProjecting()
            dismiss(animated: true)
        }
    }
    
    #warning("TODO - Project Screen Button")
    @objc private func projectScreen() {
        guard UIScreen.screens.count > 1 else { return }
        
//        #warning("we need to change the look of the controller")
//        if externalDisplay.rootViewController == nil {
//            // WE NEED TO CHANGE HOW THE DISPLAY LOOKS HERE, OR JUST BUILD A CONTROLLER.
//            let vc = TimerDisplayVC()
//            vc.delegate = self
//            ExternalDisplayManager.shared.project(detailsViewController: vc)
//            #warning("Have alert")
//        }
//
        let timerExtScnMaster = TimerExtScnMasterController(withTask: self.task)
        present(timerExtScnMaster, animated: true)


    }
    @objc func actionButtonTapped() {
        switch task.timerState {
        case .running:
            task.timerState = .paused
        case .paused, .initialized:
            task.timerState = .running
        case .ended:
            reset()
        }
    }
    @objc private func incrementButtonTapped() {
        let timeInterval = Settings.shared.timerIncrementControlSelectedValue
        task.adjustCountdownTime(modifier: .increment, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateTimeDisplayLabels()
            self.updateTitle()
        }
    }
    @objc private func decrementButtonTapped() {
        let timeInterval = Settings.shared.timerIncrementControlSelectedValue
        task.adjustCountdownTime(modifier: .decrement, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateTimeDisplayLabels()
            self.updateTitle()
        }
    }
    @objc private func resetButtonTapped() {
        reset()
    }
    @objc private func timerIncrementControlTapped(_ segmentedControl: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        settings.timerIncrementControlSelectedIndex = index
        updateButtonLabels(timeInterval: settings.timerIncrementControlSelectedValue)
    }
    private func handleTimerDidEnd() {
        let formattedTime = TimerTask.formattedTimeFrom(timeInterval: task.adjustedCountdownTime, style: .brief)
        let alert = KBTAlertController(withTitle: "TIME UP!", message: "Your \(formattedTime) timer completed.") {
            NotificationCenter.default.post(Notification.init(name: .alertDidDismiss))
        }
        present(alert, animated: true)
    }
}


// MARK: - VIEW CONTROLLER LIFECYCLE

extension TimerVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureToolBar()
        configureDigitDisplayLabel()
        configureSecondaryDigitDisplayLabel()
        configurePrimaryActionButton()
        configureStackViewButtons()
        configureTimerIncrementControl()
        configureDismissButton()
        configureProjectButton()
        configureNotificationListeners()

        configureIPhonePortraitConstraints()
        configureIPhoneLandscapeRegularConstraints()
        configureIPadAndExternalDispayConstraints()
        
        updateConstraints()
        updateTimeDisplayLabels()
        updateTitle()
        updateProjectButtonStatus()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
        updateTitle()
    }
}


//MARK: - CONFIGURATION

extension TimerVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    private func configureToolBar() {
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
    }
    private func configureDigitDisplayLabel() {
        digitDisplayLabel = KBTDigitDisplayLabel(withFontSize: 500, fontWeight: .bold, textAlignment: .center)
        view.addSubview(digitDisplayLabel)
    }
    private func configureSecondaryDigitDisplayLabel() {
        secondaryDigitDisplaylabel = KBTDigitDisplayLabel(withFontSize: 400, fontWeight: .bold, textAlignment: .center)
        secondaryDigitDisplaylabel.textColor = .tertiaryLabel
        view.addSubview(secondaryDigitDisplaylabel)
    }
    private func configurePrimaryActionButton() {
        primaryActionButton = KBTCircularButton(withSFSymbolName: ImageKeys.play)
        primaryActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        view.addSubview(primaryActionButton)
    }
    private func configureStackViewButtons() {
        decrementButton = KBTButton(withTitle: "-\(Int(Settings.shared.timerIncrementControlSelectedValue))s")
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)

        incrementButton = KBTButton(withTitle: "+\(Int(Settings.shared.timerIncrementControlSelectedValue))s")
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)

        resetButton = KBTButton(withSFSymbolName: ImageKeys.reset)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        buttonContainer = UIStackView(arrangedSubviews: [decrementButton, resetButton, incrementButton])
        buttonContainer.spacing = 20
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
    }
    private func configureTimerIncrementControl() {
        timerIncrementControl = UISegmentedControl(items: settings.timerIncrementControlValues.map { "\(Int($0))s" })
        timerIncrementControl.selectedSegmentIndex = settings.timerIncrementControlSelectedIndex
        timerIncrementControl.translatesAutoresizingMaskIntoConstraints = false
        timerIncrementControl.addTarget(self, action: #selector(timerIncrementControlTapped(_:)), for: .valueChanged)
        toolBar.addSubview(timerIncrementControl)
    }
    private func configureDismissButton() {
        guard isModalInPresentation else { return }
        let dismissButton =
            UIBarButtonItem(image: GlobalImageKeys.dismiss.image, style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = dismissButton
    }
    private func configureProjectButton() {
        let projectButton =
            UIBarButtonItem(image: GlobalImageKeys.project.image, style: .plain, target: self, action: #selector(projectScreen))
        navigationItem.rightBarButtonItem = projectButton
        self.projectButton = projectButton
    }
    private func configureNotificationListeners() {
        let center = NotificationCenter.default
        center.addObserver(forName: .timerDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.updateTimeDisplayLabels() }
        center.addObserver(forName: .timerStateDidChange, object: nil, queue: .main) { [weak self] _ in
            self?.updateActionButtonImage() }
        center.addObserver(forName: .timerDidEnd, object: nil, queue: nil) { [weak self] _ in
            self?.handleTimerDidEnd() }
        center.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { [weak self] _ in
            self?.updateProjectButtonStatus() }
        center.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { [weak self] _ in
            self?.updateProjectButtonStatus() }
    }
}


// MARK: - CONSTRAINTS

extension TimerVC {
    private func configureIPhonePortraitConstraints() {
        let verticalPadding: CGFloat = 20
        let horizontalPadding: CGFloat = 50
        let toolBarVerticalPadding: CGFloat = 8
        
        let iPhonePortraitConstraints: [NSLayoutConstraint] = [
            digitDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitDisplayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            digitDisplayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitDisplaylabel.topAnchor.constraint(equalTo: digitDisplayLabel.bottomAnchor, constant: 10),
            secondaryDigitDisplaylabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding * 2),
            secondaryDigitDisplaylabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding * 2),
            secondaryDigitDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            primaryActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryActionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: 200),
            
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetButton.heightAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 75),

            buttonContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalPadding),
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
        constraints.iPhonePortrait = iPhonePortraitConstraints
    }
    
    private func configureIPhoneLandscapeRegularConstraints() {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 75
        let toolBarVerticalPadding: CGFloat = 8
        let displayLabelToParentViewRatio: CGFloat = 0.7
        let primaryButtonSize: CGFloat = 100
        
        let iPhoneLandscapeRegularConstraints: [NSLayoutConstraint] = [
            digitDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitDisplayLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: displayLabelToParentViewRatio).withPriority(.defaultHigh),
            digitDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitDisplayLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: horizontalPadding),
            digitDisplayLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -horizontalPadding),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitDisplaylabel.topAnchor.constraint(equalTo: digitDisplayLabel.bottomAnchor),
            secondaryDigitDisplaylabel.centerXAnchor.constraint(equalTo: digitDisplayLabel.centerXAnchor),
            secondaryDigitDisplaylabel.widthAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: 0.4),
            secondaryDigitDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            primaryActionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            primaryActionButton.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalPadding),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: primaryButtonSize),
            
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetButton.heightAnchor),
            resetButton.heightAnchor.constraint(equalTo: primaryActionButton.heightAnchor, multiplier: 0.75),

            buttonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            buttonContainer.centerYAnchor.constraint(equalTo: primaryActionButton.centerYAnchor),
            
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
        constraints.iPhoneLandscapeRegular = iPhoneLandscapeRegularConstraints
    }
    
    private func configureIPadAndExternalDispayConstraints() {
        let verticalPadding: CGFloat = 40
        let horizontalPadding: CGFloat = 75
        let toolBarVerticalPadding: CGFloat = 8
        let displayLabelToParentViewRatio: CGFloat = 0.8
        let primaryButtonSize: CGFloat = 200
        
        let iPadAndExternalDisplayConstraints: [NSLayoutConstraint] = [
            digitDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitDisplayLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: displayLabelToParentViewRatio),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitDisplaylabel.topAnchor.constraint(equalTo: digitDisplayLabel.bottomAnchor),
            secondaryDigitDisplaylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryDigitDisplaylabel.widthAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: 0.5),
            secondaryDigitDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            primaryActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryActionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: primaryButtonSize),
            
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetButton.heightAnchor),
            resetButton.heightAnchor.constraint(equalTo: primaryActionButton.heightAnchor, multiplier: 0.65),

            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalPadding),
            
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
        constraints.append(forSizeClass: .iPadAndExternalDisplays, constraints: iPadAndExternalDisplayConstraints)
    }
}
