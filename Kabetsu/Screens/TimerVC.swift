//
//  TimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, TimerDisplayVCDelegate {
        
    var task: TimerTask!
    private var constraints = KBTConstraints()
    private let settings = Settings.shared
    private var projectButton: UIBarButtonItem!
    
    private var digitalDisplayLabel: KBTDigitalDisplayLabel!
    private var secondaryDigitalDisplaylabel: KBTDigitalDisplayLabel!
    
    private var primaryActionButton: KBTCircularButton!
    private var decrementButton: KBTButton!
    private var incrementButton: KBTButton!
    private var resetButton: KBTButton!
    private var buttonContainer: UIStackView!
    
    private var toolBar: UIToolbar!
    private var timerIncrementControl: UISegmentedControl!
    
    private var buttonImagePointSize: CGFloat = 80

    private struct ImageKeys {
        static let play = "play.circle"
        static let pause = "pause.circle"
        static let reset = "arrow.counterclockwise.circle"
    }
    
    init(withTask task: TimerTask) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
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
        digitalDisplayLabel.setTime(usingRawTime: task.currentCountdownTime, usingMilliseconds: true)
        secondaryDigitalDisplaylabel.setTime(usingRawTime: task.adjustedCountdownTime, usingMilliseconds: true)
    }
    private func updateActionButtonImage() {
        var imageString = ""
        switch task.timerState {
        case .running:
            imageString = ImageKeys.pause
        case .paused:
            imageString = ImageKeys.play
        case .ended:
            imageString = ImageKeys.reset
        }
        let config = UIImage.SymbolConfiguration(pointSize: buttonImagePointSize, weight: .regular)
        let image = UIImage(systemName: imageString, withConfiguration: config)
        primaryActionButton.setImage(image, for: .normal)
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
    private func updateActionButtonImageSize() {
        buttonImagePointSize = traitCollection.verticalSizeClass == .compact ? 80 : 300
        updateActionButtonImage()
    }
}



// MARK: - ACTIONS

extension TimerVC {
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    @objc private func projectScreen() {
        print("ProjectScreen button tapped")
        #warning("TODO - Project Screen Button")
        
        // WE NEED TO CHANGE HOW THE DISPLAY LOOKS HERE, OR JUST BUILD A CONTROLLER.

        let vc = TimerDisplayVC()
        vc.delegate = self
        ExternalDisplayManager.shared.project(detailsViewController: vc)

    }
    @objc func actionButtonTapped() {
        switch task.timerState {
        case .running:
            task.timerState = .paused
        case .paused:
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
        configureDigitalDisplayLabel()
        configureSecondaryDigitalDisplayLabel()
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
        updateActionButtonImageSize()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
        updateTitle()
        updateActionButtonImageSize()
    }
}


//MARK: - CONFIGURATION

extension TimerVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        //isModalInPresentation = true
    }
    private func configureToolBar() {
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
    }
    private func configureDigitalDisplayLabel() {
        digitalDisplayLabel = KBTDigitalDisplayLabel(withFontSize: 500, fontWeight: .bold, textAlignment: .center)
        view.addSubview(digitalDisplayLabel)
    }
    private func configureSecondaryDigitalDisplayLabel() {
        secondaryDigitalDisplaylabel = KBTDigitalDisplayLabel(withFontSize: 400, fontWeight: .bold, textAlignment: .center)
        secondaryDigitalDisplaylabel.textColor = .tertiaryLabel
        view.addSubview(secondaryDigitalDisplaylabel)
    }
    private func configurePrimaryActionButton() {
        primaryActionButton = KBTCircularButton(withSFSymbolName: ImageKeys.play, pointSize: buttonImagePointSize)
        primaryActionButton.backgroundColor = .systemGreen
        primaryActionButton.tintColor = .white
        primaryActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        view.addSubview(primaryActionButton)
    }
    private func configureStackViewButtons() {
        decrementButton = KBTButton(withTitle: "-\(Int(Settings.shared.timerIncrementControlSelectedValue))s")
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)

        incrementButton = KBTButton(withTitle: "+\(Int(Settings.shared.timerIncrementControlSelectedValue))s")
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)

        resetButton = KBTButton(withSFSymbolName: ImageKeys.reset, pointSize: 40)
        resetButton.backgroundColor = .systemGreen
        resetButton.tintColor = .white
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
        let dismissButton = UIBarButtonItem(image: GlobalImageKeys.dismiss.image,
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissController))
        navigationItem.leftBarButtonItem = dismissButton
    }
    private func configureProjectButton() {
        let projectButton = UIBarButtonItem(image: GlobalImageKeys.project.image,
                                            style: .plain,
                                            target: self,
                                            action: #selector(projectScreen))
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
//        center.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { [weak self] _ in
//            self?.projectButton.isEnabled = true }
//        center.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { [weak self] _ in
//            self?.projectButton.isEnabled = false }
    }
}


// MARK: - CONSTRAINTS

extension TimerVC {
    private func configureIPhonePortraitConstraints() {
        let verticalPadding: CGFloat = 20
        let horizontalPadding: CGFloat = 50
        let toolBarVerticalPadding: CGFloat = 8
        
        let iPhonePortraitConstraints: [NSLayoutConstraint] = [
            digitalDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitalDisplayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            digitalDisplayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            digitalDisplayLabel.heightAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor, constant: 10),
            secondaryDigitalDisplaylabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding * 2),
            secondaryDigitalDisplaylabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding * 2),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitalDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
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
            digitalDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitalDisplayLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: displayLabelToParentViewRatio).withPriority(.defaultHigh),
            digitalDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitalDisplayLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: horizontalPadding),
            digitalDisplayLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -horizontalPadding),
            digitalDisplayLabel.heightAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor),
            secondaryDigitalDisplaylabel.centerXAnchor.constraint(equalTo: digitalDisplayLabel.centerXAnchor),
            secondaryDigitalDisplaylabel.widthAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: 0.4),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitalDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
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
            digitalDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            digitalDisplayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitalDisplayLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: displayLabelToParentViewRatio),
            digitalDisplayLabel.heightAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor),
            secondaryDigitalDisplaylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryDigitalDisplaylabel.widthAnchor.constraint(equalTo: digitalDisplayLabel.widthAnchor, multiplier: 0.5),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitalDisplaylabel.widthAnchor, multiplier: UIHelpers.digitalDisplayFontHeightToWidthRatio),
            
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
