//
//  TimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {
    
    private var task: TimerTask!
    private var constraints: Constraints!
    private let settings = Settings.shared
    
    private var digitalDisplayLabel: KBTDigitalDisplayLabel!
    private var secondaryDigitalDisplaylabel: KBTDigitalDisplayLabel!
    
    private var primaryActionButton: KBTCircularButton!
    private var decrementButton: KBTButton!
    private var incrementButton: KBTButton!
    private var resetButton: KBTButton!
    
    private var buttonContainer: UIStackView!
    
    private var toolBar: UIToolbar!
    private var adjustIntervalControl: UISegmentedControl!
    
    private let buttonImagePointSize: CGFloat = 100


    private struct ImageKeys {
        static let play = "play.circle"
        static let pause = "pause.circle"
        static let reset = "arrow.counterclockwise.circle"
        static let dismiss = "multiply"
        static let project = "tv"
    }
    

    init(withTask task: TimerTask) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
        modalTransitionStyle = .flipHorizontal
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func updateUI() {
        digitalDisplayLabel.setTime(usingRawTime: task.currentCountdownTime, usingMilliseconds: true)
        secondaryDigitalDisplaylabel.setTime(usingRawTime: task.adjustedCountdownTime, usingMilliseconds: true)
    }
    
    private func updateButtonLabels(timeInterval: Double) {
        decrementButton.setTitle("-\(Int(timeInterval))s", for: .normal)
        incrementButton.setTitle("+\(Int(timeInterval))s", for: .normal)
    }
    
    private func reset() {
        task = TimerTask(withTotalTime: task.originalCountdownTime)
        updateUI()
        timerStateDidChange()
    }
    
    private func timerStateDidChange() {
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
    
    private func handleTimerDidEnd() {
        print("Handle TimerDidEnd")
        #warning("FIX ME - Handle Timer did End")
    }
    
}



// MARK: - Button Actions

extension TimerVC {
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    @objc private func projectScreen() {
        print("ProjectScreen button tapped")
        #warning("TODO - Project Screen Button")
        
        /*  We want to do two things when we project.
            we need to present a controller VC onto the device and a seperate projectorVC for the external screen
            we can present modally over another modal provided by setting the modalstyle to overfullscreen.
            
         */
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
        let timeInterval = Settings.shared.adjustIntervalSegConCurrentIncrementValue
        task.adjustCountdownTime(modifier: .increment, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateUI()
        }
    }
    @objc private func decrementButtonTapped() {
        let timeInterval = Settings.shared.adjustIntervalSegConCurrentIncrementValue
        task.adjustCountdownTime(modifier: .decrement, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateUI()
        }
    }
    @objc private func resetButtonTapped() {
        reset()
    }
    @objc private func adjustIntervalControlTapped(_ segmentedControl: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        settings.adjustIntervalSegConSelectedIndex = index
        updateButtonLabels(timeInterval: settings.adjustIntervalSegConCurrentIncrementValue)
    }
}



// MARK: - View Controller Lifecycle
extension TimerVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNotificationListeners()
        configureDigitalDisplayLabel()
        configureSecondaryDigitalDisplayLabel()
        configurePrimaryActionButton()
        configureStackViewButtons()
        configureAdjustIntervalControl()
        configureDismissButton()
        configureProjectButton()
        
        configureConstraintsForRegular()
        updateConstraints()
        
        updateUI()
        
    }
}



//MARK: - Configuration

extension TimerVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        isModalInPresentation = true
        
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        
        constraints = Constraints()
    }
    private func configureNotificationListeners() {
        let center = NotificationCenter.default
        center.addObserver(forName: .timerDidUpdate, object: nil, queue: .main) { _ in self.updateUI() }
        center.addObserver(forName: .timerStateDidChange, object: nil, queue: .main) { _ in self.timerStateDidChange() }
        center.addObserver(forName: .timerDidEnd, object: nil, queue: nil) { _ in self.handleTimerDidEnd() }
    }
    private func configureDigitalDisplayLabel() {
        digitalDisplayLabel = KBTDigitalDisplayLabel(withFontSize: 50, fontWeight: .bold, textAlignment: .center)
        view.addSubview(digitalDisplayLabel)
    }
    private func configureSecondaryDigitalDisplayLabel() {
        secondaryDigitalDisplaylabel = KBTDigitalDisplayLabel(withFontSize: 30, fontWeight: .bold, textAlignment: .center)
        secondaryDigitalDisplaylabel.textColor = .tertiaryLabel
        view.addSubview(secondaryDigitalDisplaylabel)
    }
    
    private func configurePrimaryActionButton() {
        primaryActionButton = KBTCircularButton(withSFSymbolName: ImageKeys.play, pointSize: buttonImagePointSize)
        primaryActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        view.addSubview(primaryActionButton)
    }
    private func configureStackViewButtons() {
        decrementButton = KBTButton(withTitle: "-\(Int(Settings.shared.adjustIntervalSegConCurrentIncrementValue))s")
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)

        incrementButton = KBTButton(withTitle: "+\(Int(Settings.shared.adjustIntervalSegConCurrentIncrementValue))s")
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)

        resetButton = KBTButton(withSFSymbolName: ImageKeys.reset, pointSize: 40)
        resetButton.backgroundColor = .systemGreen
        resetButton.tintColor = .white
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        buttonContainer = UIStackView(arrangedSubviews: [decrementButton, resetButton, incrementButton])
        buttonContainer.spacing = 10
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonContainer)
    }
    private func configureAdjustIntervalControl() {
        adjustIntervalControl = UISegmentedControl(items: settings.adjustIntervalSegConIncrements.map { "\($0)" })
        adjustIntervalControl.selectedSegmentIndex = settings.adjustIntervalSegConSelectedIndex
        adjustIntervalControl.translatesAutoresizingMaskIntoConstraints = false
        adjustIntervalControl.addTarget(self, action: #selector(adjustIntervalControlTapped(_:)), for: .valueChanged)
        toolBar.addSubview(adjustIntervalControl)
    }
    
    
    
    private func configureDismissButton() {
        let config = UIHelpers.symbolConfig
        let dismissImage = UIImage(systemName: ImageKeys.dismiss, withConfiguration: config)
        let dismissButton = UIBarButtonItem(image: dismissImage, style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = dismissButton
    }
    private func configureProjectButton() {
        let config = UIHelpers.symbolConfig
        let projectImage = UIImage(systemName: ImageKeys.project, withConfiguration: config)
        let projectButton = UIBarButtonItem(image: projectImage, style: .plain, target: self, action: #selector(projectScreen))
        navigationItem.rightBarButtonItem = projectButton
    }
}


// MARK: - Constraints

extension TimerVC {
    
    private var padding: CGFloat { return 20 }
    private var paddingThin: CGFloat { return 8 }
    private var paddingThick: CGFloat { return 50 }
    
    private func configureConstraintsForRegular() {
        var regularConstraints: [NSLayoutConstraint] = [
            digitalDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            digitalDisplayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            digitalDisplayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            digitalDisplayLabel.heightAnchor.constraint(equalToConstant: 50),
            
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor, constant: 10),
            secondaryDigitalDisplaylabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            secondaryDigitalDisplaylabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalToConstant: 30),
            
            primaryActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryActionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: 100),
            
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.heightAnchor.constraint(equalTo: resetButton.widthAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 75),

            buttonContainer.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            adjustIntervalControl.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: paddingThin),
            adjustIntervalControl.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -paddingThin),
            adjustIntervalControl.leadingAnchor.constraint(greaterThanOrEqualTo: toolBar.leadingAnchor, constant: padding),
            adjustIntervalControl.trailingAnchor.constraint(lessThanOrEqualTo: toolBar.trailingAnchor, constant: -padding),
            adjustIntervalControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
        ]
        let adjustIntervalControlWidthConstraint = adjustIntervalControl.widthAnchor.constraint(equalToConstant: 800)
        adjustIntervalControlWidthConstraint.priority = .defaultHigh
        regularConstraints.append(adjustIntervalControlWidthConstraint)

        constraints.regular = regularConstraints
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
    private func updateConstraints() {
//        if traitCollection.verticalSizeClass == .compact {
//            constraints.activate(.verticallyCompact)
//            return
//        }
        constraints.activate(.regular)
    }
}
