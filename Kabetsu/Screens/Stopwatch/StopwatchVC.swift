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
    
    private var projectButton: UIBarButtonItem!
    private let externalDisplay = ExternalDisplayManager.shared
    
    private var digitDisplay: KBTDigitDisplayLabel!
    private var digitDisplayContainer: UIView!

    private var primaryActionButton: KBTButton!
    private var resetButton: KBTButton!
    private var logButton: KBTButton!
    private var buttonContainer: UIView!
    
    private var cellCounter: Int = 0
//    UITraitCollection.current.verticalSizeClass == .compact
    
    private enum Section: Int, CaseIterable {
        case main
        var columnCount: Int {
            return UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
        }
    }
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section,TimeInterval>!
    
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
    private func updateCollectionView(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TimeInterval>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(stopwatch.logTimes.reversed())
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    private func updateConstraints() {
        if traitCollection.verticalSizeClass == .compact {
            constraints.activate(.iPhoneLandscapeRegular)
            return
        }
        constraints.activate(.universal)
    }
    private func updateProjectButtonStatus() {
         projectButton.isEnabled =  UIScreen.screens.count > 1 ? true : false
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
        cellCounter = 0
        updatePrimaryActionButtonImage()
    }
    @objc private func logButtonTapped() {
        stopwatch.logTime()
    }
    @objc private func settingsButtonTapped(sender: Any) {
        guard let sender = sender as? UIBarButtonItem else { return }
        let settingsVC = SettingsVC()
        let navCon = UINavigationController(rootViewController: settingsVC)
        navCon.modalPresentationStyle = .popover
        let popOver = navCon.popoverPresentationController!
        popOver.barButtonItem = sender
        popOver.sourceView = self.view
        present(navCon, animated: true)
    }
    @objc private func projectScreen() {
        guard UIScreen.screens.count > 1 else { return }
        guard externalDisplay.rootViewController == nil else {
            externalDisplay.endProjecting()
            return
        }
        if externalDisplay.rootViewController == nil {
            
//            let detailsView = TimerExtScnDetails()
//            detailsView.delegate = self
            //externalDisplay.project(detailsViewController: detailsView)
        }
    }
}


// MARK: VIEW CONTROLLER LIFECYCLE

extension StopwatchVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureBarButtonItems()
        configureDigitDisplayLabel()
        configureButtons()
        configureCollectionView()
        configureDataSource()
        configureNotificationListeners()
        
        configureUniversalConstraints()
        configureiPhoneLandscapeRegularConstraints()
        updateConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
}


// MARK: CONFIGURATION

extension StopwatchVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Stopwatch"
    }
    private func configureProjectButton() {
        let projectButton =
            UIBarButtonItem(image: GlobalImageKeys.project.image, style: .plain, target: self, action: #selector(projectScreen))
            navigationItem.rightBarButtonItem = projectButton
        self.projectButton = projectButton
    }
    private func configureBarButtonItems() {
        let config = GlobalImageKeys.symbolConfig()
        let settingsImage = UIImage(systemName: GlobalImageKeys.settings.rawValue, withConfiguration: config)
        let projectImage = UIImage(systemName: GlobalImageKeys.project.rawValue, withConfiguration: config)
        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        projectButton = UIBarButtonItem(image: projectImage, style: .plain, target: self, action: #selector(projectScreen))
        navigationItem.leftBarButtonItem = settingsBarButton
        navigationItem.rightBarButtonItem = projectButton
    }
    private func configureDigitDisplayLabel() {
        digitDisplay = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .center)
        digitDisplay.font = UIFont(name: "HelveticaNeue-medium", size: 1000)
        digitDisplay.textColor = KBTColors.primaryLabel
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
        stackView.spacing = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let primaryToSecondaryButtonWidthRatio: CGFloat = 0.6
        
        NSLayoutConstraint.activate([
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: 140).withPriority(.defaultHigh),
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
            stackView.heightAnchor.constraint(lessThanOrEqualTo: buttonContainer.heightAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: buttonContainer.widthAnchor),
        ])
        
        view.addSubview(buttonContainer)
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureAdaptiveLayout())
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(StopwatchLogCell.self, forCellWithReuseIdentifier: StopwatchLogCell.reuseId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    private func configureNotificationListeners() {
        let center = NotificationCenter.default
        center.addObserver(forName: .stopwatchDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.updateUI() }
        center.addObserver(forName: .logTimesDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.updateCollectionView(animated: true) }
        center.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { [weak self] _ in
            self?.updateProjectButtonStatus() }
        center.addObserver(forName: UIScreen.didDisconnectNotification, object: nil, queue: nil) { [weak self] _ in
            self?.updateProjectButtonStatus() }
    }
}

// MARK: COLLECTION VIEW CONFIGURATION

extension StopwatchVC {
    private func configureAdaptiveLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionEnum = Section(rawValue: sectionIndex) else { return  nil }
            let columns = sectionEnum.columnCount
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            return NSCollectionLayoutSection(group: group)
        }
        return layout
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,TimeInterval>(collectionView: collectionView) {
            (collectionView, indexPath, timeInterval) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StopwatchLogCell.reuseId, for: indexPath) as! StopwatchLogCell
            cell.counter.text = "\(self.cellCounter) :"
            cell.title.setTime(usingRawTime: timeInterval, usingMilliseconds: true)
            self.cellCounter += 1
            return cell
        }
    }
}

// MARK: CONSTRAINTS

extension StopwatchVC {
    
    private func configureUniversalConstraints() {
        
        let horizontalEdgeInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 20
        let verticalEdgeInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 8

        let universalConstraints: [NSLayoutConstraint] = [
            digitDisplayContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            digitDisplayContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            digitDisplayContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            digitDisplayContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            buttonContainer.topAnchor.constraint(equalTo: digitDisplayContainer.bottomAnchor, constant: verticalEdgeInset),
            buttonContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalEdgeInset),
            buttonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            buttonContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: verticalEdgeInset),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalEdgeInset),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        constraints.append(forSizeClass: .universal, constraints: universalConstraints)
    }
    
    private func configureiPhoneLandscapeRegularConstraints() {
        let horizontalEdgeInset: CGFloat = 20
        let verticalEdgeInset: CGFloat = 20
        let iPhoneLandscapeRegularConstraints: [NSLayoutConstraint] = [
            digitDisplayContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            digitDisplayContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            digitDisplayContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            digitDisplayContainer.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -verticalEdgeInset),
            
            buttonContainer.topAnchor.constraint(equalTo: digitDisplayContainer.bottomAnchor),
            buttonContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: horizontalEdgeInset),
            buttonContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalEdgeInset),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalEdgeInset),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalEdgeInset),
            collectionView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalEdgeInset)
        ]
        constraints.append(forSizeClass: .iPhoneLandscapeRegular, constraints: iPhoneLandscapeRegularConstraints)
    }
}
