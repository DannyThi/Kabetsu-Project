//
//  StopwatchVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/05.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class StopwatchVC: UIViewController {
    
    private var stopwatch = Stopwatch()
    private var settings = Settings.shared
    private var constraints = KBTConstraints()
    
    private var digitDisplay: KBTDigitDisplayLabel!
    private var digitDisplayContainer: UIView!

    private var primaryActionButton: KBTButton!
    private var resetButton: KBTButton!
    private var logButton: KBTButton!
    private var buttonContainer: UIView!

    private var collectionView: UICollectionView!
    
}

// MARK: UI UPDATES

extension StopwatchVC {
    
    private func updateUI() {
        digitDisplay.setTime(usingRawTime: stopwatch.elapsedTime, usingMilliseconds: true)
    }
    
    private func updatePrimaryActionButtonImage() {
        var imageString: String
        switch stopwatch.watchState {
        case .paused, .resetted:
            imageString = GlobalImageKeys.play.rawValue
        case .running:
            imageString = GlobalImageKeys.pause.rawValue
        }
        primaryActionButton.updateSymbolImage(symbolName: imageString)
    }
}


// MARK: ACTIONS

extension StopwatchVC {
    
    @objc private func primaryActionButtonTapped() {
        switch stopwatch.watchState {
        case .paused, .resetted:
            stopwatch.watchState = .running
        case .running:
            stopwatch.watchState = .paused
        }
        updatePrimaryActionButtonImage()
    }
    @objc private func resetButtonTapped() {
        stopwatch.watchState = .resetted
        updatePrimaryActionButtonImage()
    }
    @objc private func logButtonTapped() {
        
    }
}


// MARK: VIEW CONTROLLER LIFECYCLE

extension StopwatchVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureDigitDisplayLabel()
        configureButtons()
        configureCollectionView()
        configureNotificationListeners()
        
        configureUniversalConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
}


// MARK: CONFIGURATION

extension StopwatchVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Stopwatch"
    }
    private func configureDigitDisplayLabel() {
        digitDisplay = KBTDigitDisplayLabel(textAlignment: .center)
        digitDisplay.setTime(usingRawTime: stopwatch.elapsedTime, usingMilliseconds: true)
        
        digitDisplayContainer = UIView()
        //digitDisplayContainer.backgroundColor = .green
        digitDisplayContainer.translatesAutoresizingMaskIntoConstraints = false
        digitDisplayContainer.addSubview(digitDisplay)
        
        NSLayoutConstraint.activate([
            digitDisplay.centerXAnchor.constraint(equalTo: digitDisplayContainer.centerXAnchor),
            digitDisplay.centerYAnchor.constraint(equalTo: digitDisplayContainer.centerYAnchor),
            digitDisplay.widthAnchor.constraint(equalTo: digitDisplayContainer.widthAnchor, multiplier: 0.8),
            digitDisplay.heightAnchor.constraint(equalTo: digitDisplay.widthAnchor,
                                                 multiplier: Constants.ViewAppearance.digitalDisplayFontHeightToWidthRatio),
            digitDisplayContainer.heightAnchor.constraint(greaterThanOrEqualTo: digitDisplay.heightAnchor)
        ])
        view.addSubview(digitDisplayContainer)
    }
    private func configureButtons() {
        primaryActionButton = KBTCircularButton(withSFSymbolName: GlobalImageKeys.play.rawValue)
        primaryActionButton.addTarget(self, action: #selector(primaryActionButtonTapped), for: .touchUpInside)
        resetButton = KBTCircularButton(withSFSymbolName: GlobalImageKeys.reset.rawValue)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        logButton = KBTCircularButton(withSFSymbolName: GlobalImageKeys.log.rawValue)
        logButton.addTarget(self, action: #selector(logButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [logButton, primaryActionButton, resetButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let primaryToSecondaryButtonWidthRatio: CGFloat = 0.7
        
        NSLayoutConstraint.activate([
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalTo: resetButton.widthAnchor),
            resetButton.widthAnchor.constraint(equalTo: primaryActionButton.widthAnchor, multiplier: primaryToSecondaryButtonWidthRatio),
            logButton.heightAnchor.constraint(equalTo: logButton.widthAnchor),
            logButton.widthAnchor.constraint(equalTo: primaryActionButton.widthAnchor, multiplier: primaryToSecondaryButtonWidthRatio),
        ])
        
        buttonContainer = UIView()
        //buttonContainer.backgroundColor = .systemPurple
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
            buttonContainer.heightAnchor.constraint(greaterThanOrEqualTo: stackView.heightAnchor),
            buttonContainer.widthAnchor.constraint(greaterThanOrEqualTo: stackView.widthAnchor),
        ])
        
        view.addSubview(buttonContainer)
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        //collectionView.backgroundColor = .systemRed
//        collectionView.delegate = self
//        collectionView.register(someclass, forCellWithReuseIdentifier: someID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    private func configureNotificationListeners() {
        let center = NotificationCenter.default
        center.addObserver(forName: .stopwatchDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.updateUI()
        }
    }
}

// MARK: CONSTRAINTS

extension StopwatchVC {
    
    private func configureUniversalConstraints() {
        let universalConstraints: [NSLayoutConstraint] = [
            digitDisplayContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            digitDisplayContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            digitDisplayContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            digitDisplayContainer.heightAnchor.constraint(equalToConstant: 200),
            
            buttonContainer.topAnchor.constraint(equalTo: digitDisplayContainer.bottomAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        constraints.append(forSizeClass: .universal, constraints: universalConstraints)
        constraints.activate(.universal)
    }
}
