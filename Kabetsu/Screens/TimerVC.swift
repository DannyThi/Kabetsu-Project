//
//  TimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, TimerExtScnDetailsDelegate {
        
    var task: TimerTask!
    var constraints = KBTConstraints()
    let externalDisplay = ExternalDisplayManager.shared
    
    let settings = Settings.shared
    var projectButton: UIBarButtonItem!
    
    var digitDisplayLabel: KBTDigitDisplayLabel!
    var secondaryDigitDisplaylabel: KBTDigitDisplayLabel!
    var digitLabelsLayoutContainer: UIView!
    
    var primaryActionButton: KBTCircularButton!
    var primaryButtonsContainer: UIView!
    
    var decrementButton: KBTButton!
    var incrementButton: KBTButton!
    var resetButton: KBTButton!
    var secondaryButtonsContainer: UIView!
    
    var toolBar: UIToolbar!
    var timerIncrementControl: UISegmentedControl!
    
    private struct ImageKeys {
        static let play = "play"
        static let pause = "pause"
        static let reset = "arrow.counterclockwise"
        static let dismiss = "x"
    }
    
    init(withTask task: TimerTask?) {
        super.init(nibName: nil, bundle: nil)
        if let task = task {
            self.task = task
        }
        hidesBottomBarWhenPushed = true
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
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
    func updateTimeDisplayLabels() {
        digitDisplayLabel.setTime(usingRawTime: task.currentCountdownTime, usingMilliseconds: true)
        secondaryDigitDisplaylabel.setTime(usingRawTime: task.adjustedCountdownTime, usingMilliseconds: true)
    }
    func updateActionButtonImage() {
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
    func updateConstraints() {
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
    @objc func dismissController() {
        if task.timerState != .initialized {
            let ac = UIAlertController(title: "Timer is running.",
                                       message: "Your timer is still running. Exit anyway?",
                                       preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
                self?.externalDisplay.endProjecting()
                self?.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            ac.addAction(cancel)
            ac.addAction(ok)
            present(ac, animated: true)
        } else {
            externalDisplay.endProjecting()
            dismiss(animated: true)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func projectScreen() {
        guard UIScreen.screens.count > 1 else { return }
        guard externalDisplay.rootViewController == nil else {
            externalDisplay.endProjecting()
            return
        }
        if externalDisplay.rootViewController == nil {
            let detailsView = TimerExtScnDetails()
            detailsView.delegate = self
            externalDisplay.project(detailsViewController: detailsView)
        }
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
    @objc func handleTimerDidEnd() {
        guard navigationController?.topViewController == self else { return }
        
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
        configureDigitLabels()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
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
        print(settings.currentAlertSound.title)
    }
    private func configureToolBar() {
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
    }
    
    private func configureDigitLabels() {
        digitDisplayLabel = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .center)
        digitDisplayLabel.font = UIFont(name: "HelveticaNeue-medium", size: 1000)
        digitDisplayLabel.textColor = KBTColors.primaryLabel
        
        secondaryDigitDisplaylabel = KBTDigitDisplayLabel(fontSize: 400, fontWeight: .bold, textAlignment: .center)
        secondaryDigitDisplaylabel.font = UIFont(name: "HelveticaNeue-thin", size: 1000)
        secondaryDigitDisplaylabel.textColor = KBTColors.secondaryLabel
        
        let labelGroup = UIView()
        labelGroup.translatesAutoresizingMaskIntoConstraints = false
        labelGroup.addSubview(digitDisplayLabel)
        labelGroup.addSubview(secondaryDigitDisplaylabel)
        
        NSLayoutConstraint.activate([
            digitDisplayLabel.topAnchor.constraint(equalTo: labelGroup.topAnchor),
            digitDisplayLabel.leadingAnchor.constraint(equalTo: labelGroup.leadingAnchor),
            digitDisplayLabel.trailingAnchor.constraint(equalTo: labelGroup.trailingAnchor),
            digitDisplayLabel.heightAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor,
                                                      multiplier: Constants.ViewAppearance.digitalDisplayFontHeightToWidthRatio),
            
            secondaryDigitDisplaylabel.topAnchor.constraint(equalTo: digitDisplayLabel.bottomAnchor, constant: 8),
            secondaryDigitDisplaylabel.widthAnchor.constraint(equalTo: digitDisplayLabel.widthAnchor, multiplier: 0.5),
            secondaryDigitDisplaylabel.heightAnchor.constraint(equalTo: secondaryDigitDisplaylabel.widthAnchor,
                                                      multiplier: Constants.ViewAppearance.digitalDisplayFontHeightToWidthRatio),
            secondaryDigitDisplaylabel.bottomAnchor.constraint(equalTo: labelGroup.bottomAnchor),
            secondaryDigitDisplaylabel.centerXAnchor.constraint(equalTo: digitDisplayLabel.centerXAnchor)
        ])
        
        digitLabelsLayoutContainer = UIView()
        digitLabelsLayoutContainer.translatesAutoresizingMaskIntoConstraints = false
        digitLabelsLayoutContainer.addSubview(labelGroup)
        
        NSLayoutConstraint.activate([
            labelGroup.centerXAnchor.constraint(equalTo: digitLabelsLayoutContainer.centerXAnchor),
            labelGroup.centerYAnchor.constraint(equalTo: digitLabelsLayoutContainer.centerYAnchor, constant: -10),
            labelGroup.widthAnchor.constraint(equalTo: digitLabelsLayoutContainer.widthAnchor, multiplier: 0.9),
        ])
        view.addSubview(digitLabelsLayoutContainer)
    }

    private func configurePrimaryActionButton() {
        primaryActionButton = KBTCircularButton(withSFSymbolName: ImageKeys.play)
        primaryActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        primaryButtonsContainer = UIView()
        primaryButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        primaryButtonsContainer.addSubview(primaryActionButton)
        
        NSLayoutConstraint.activate([
            primaryActionButton.centerXAnchor.constraint(equalTo: primaryButtonsContainer.centerXAnchor),
            primaryActionButton.centerYAnchor.constraint(equalTo: primaryButtonsContainer.centerYAnchor),
            primaryActionButton.widthAnchor.constraint(equalTo: primaryButtonsContainer.widthAnchor, multiplier: 0.6),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
        ])
        
        view.addSubview(primaryButtonsContainer)
    }
    
    private func configureStackViewButtons() {
        decrementButton = KBTCircularButton(withTitle: "-\(Int(Settings.shared.timerIncrementControlSelectedValue))s", fontSize: 25)
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        incrementButton = KBTCircularButton(withTitle: "+\(Int(Settings.shared.timerIncrementControlSelectedValue))s", fontSize: 25)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        resetButton = KBTCircularButton(withSFSymbolName: ImageKeys.reset)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
                
        let stackView = UIStackView(arrangedSubviews: [decrementButton, resetButton, incrementButton])
        
        stackView.spacing = UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        secondaryButtonsContainer = UIView()
        secondaryButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        secondaryButtonsContainer.addSubview(stackView)
        
        let buttonHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 90
        
        NSLayoutConstraint.activate([
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: resetButton.heightAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            stackView.centerXAnchor.constraint(equalTo: secondaryButtonsContainer.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: secondaryButtonsContainer.centerYAnchor),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: secondaryButtonsContainer.heightAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: secondaryButtonsContainer.widthAnchor),
        ])
        view.addSubview(secondaryButtonsContainer)
    }
    private func configureTimerIncrementControl() {
        timerIncrementControl = UISegmentedControl(items: settings.timerIncrementControlValues.map { "\(Int($0))s" })
        timerIncrementControl.selectedSegmentIndex = settings.timerIncrementControlSelectedIndex
        timerIncrementControl.translatesAutoresizingMaskIntoConstraints = false
        timerIncrementControl.addTarget(self, action: #selector(timerIncrementControlTapped(_:)), for: .valueChanged)
        toolBar.addSubview(timerIncrementControl)
    }
    private func configureDismissButton() {
        //guard isModalInPresentation else { return }
        let dismissButton =
            UIBarButtonItem(image: GlobalImageKeys.dismissFill.image, style: .plain, target: self, action: #selector(dismissController))
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
    @objc func configureIPhonePortraitConstraints() {
        let horizontalPadding: CGFloat = 50
        let toolBarVerticalPadding: CGFloat = 8
        
        let iPhonePortraitConstraints: [NSLayoutConstraint] = [
            digitLabelsLayoutContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            digitLabelsLayoutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            digitLabelsLayoutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            digitLabelsLayoutContainer.bottomAnchor.constraint(equalTo: primaryButtonsContainer.topAnchor),

            primaryButtonsContainer.heightAnchor.constraint(equalTo: primaryActionButton.heightAnchor),
            primaryButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryButtonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButtonsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: secondaryButtonsContainer.topAnchor),
            
            secondaryButtonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secondaryButtonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            secondaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),

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
    @objc func configureIPhoneLandscapeRegularConstraints() {
        let verticalEdgeInset: CGFloat = 20
        let horizontalEdgeInset: CGFloat = 90
        let toolBarVerticalPadding: CGFloat = 8
        
        let iPhoneLandscapeRegularConstraints: [NSLayoutConstraint] = [
            digitLabelsLayoutContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            digitLabelsLayoutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalEdgeInset),
            digitLabelsLayoutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            digitLabelsLayoutContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -verticalEdgeInset),

            primaryButtonsContainer.heightAnchor.constraint(equalTo: primaryActionButton.heightAnchor),
            primaryButtonsContainer.topAnchor.constraint(equalTo: digitLabelsLayoutContainer.bottomAnchor, constant: -verticalEdgeInset),
            primaryButtonsContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalEdgeInset),
            
            secondaryButtonsContainer.centerYAnchor.constraint(equalTo: primaryButtonsContainer.centerYAnchor, constant: verticalEdgeInset),
            secondaryButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secondaryButtonsContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),

            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 40),
            
            timerIncrementControl.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: toolBarVerticalPadding),
            timerIncrementControl.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -toolBarVerticalPadding),
            timerIncrementControl.leadingAnchor.constraint(greaterThanOrEqualTo: toolBar.leadingAnchor, constant: horizontalEdgeInset),
            timerIncrementControl.trailingAnchor.constraint(lessThanOrEqualTo: toolBar.trailingAnchor, constant: -horizontalEdgeInset),
            timerIncrementControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            timerIncrementControl.widthAnchor.constraint(equalToConstant: 800).withPriority(.defaultHigh)
        ]
        constraints.iPhoneLandscapeRegular = iPhoneLandscapeRegularConstraints
    }
    
    @objc func configureIPadAndExternalDispayConstraints() {
        let verticalEdgeInset: CGFloat = 40
        let horizontalEdgeInset: CGFloat = 40
        let toolBarVerticalInset: CGFloat = 8
        
        var primaryButtonSize: CGFloat { return CGFloat.minimum(view.bounds.width, view.bounds.height) * 0.5}

        let iPadAndExternalDisplayConstraints: [NSLayoutConstraint] = [
            digitLabelsLayoutContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            digitLabelsLayoutContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            digitLabelsLayoutContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            digitLabelsLayoutContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            primaryButtonsContainer.heightAnchor.constraint(equalTo: primaryActionButton.heightAnchor).withPriority(.defaultHigh),
            primaryButtonsContainer.widthAnchor.constraint(equalToConstant: primaryButtonSize),
            primaryButtonsContainer.topAnchor.constraint(equalTo: digitLabelsLayoutContainer.bottomAnchor, constant: -verticalEdgeInset),
            primaryButtonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            primaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -verticalEdgeInset),
            
            secondaryButtonsContainer.centerYAnchor.constraint(equalTo: primaryButtonsContainer.centerYAnchor),
            secondaryButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secondaryButtonsContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            secondaryButtonsContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),

            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50),
            
            timerIncrementControl.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: toolBarVerticalInset),
            timerIncrementControl.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -toolBarVerticalInset),
            timerIncrementControl.leadingAnchor.constraint(greaterThanOrEqualTo: toolBar.leadingAnchor, constant: horizontalEdgeInset),
            timerIncrementControl.trailingAnchor.constraint(lessThanOrEqualTo: toolBar.trailingAnchor, constant: -horizontalEdgeInset),
            timerIncrementControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            timerIncrementControl.widthAnchor.constraint(equalToConstant: 800).withPriority(.defaultHigh)
        ]
        constraints.append(forSizeClass: .iPadAndExternalDisplays, constraints: iPadAndExternalDisplayConstraints)
    }
}
