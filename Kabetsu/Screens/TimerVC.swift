//
//  TimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/29.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {
    
    private(set) var task: TimerTask!
    
    let digitalDisplayLabel = KBTDigitalDisplayLabel(withFontSize: 50, fontWeight: .bold, textAlignment: .center)
    let secondaryDigitalDisplaylabel = KBTDigitalDisplayLabel(withFontSize: 30, fontWeight: .bold, textAlignment: .center)
    let primaryActionButton = KBTCircularButton(withSFSymbolName: "play.circle.fill", pointSize: 100)
    
    let decrementButton = KBTButton(withTitle: "-\(Int(Settings.shared.timeIncrement))s")
    let incrementButton = KBTButton(withTitle: "+\(Int(Settings.shared.timeIncrement))s")
    let resetButton: KBTButton = {
        let button = KBTButton(withSFSymbolName: "arrow.counterclockwise", pointSize: 40)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureDismissButton()
        configureProjectButton()
        configureDigitalDisplayLabel()
        configureSecondaryDigitalDisplayLabel()
        configurePrimaryActionButton()
        configureStackViewButtons()
        updateUI()
    }
    
    private func updateUI() {
        digitalDisplayLabel.setTime(usingRawTime: task.currentCountdownTime, usingMilliseconds: true)
        secondaryDigitalDisplaylabel.setTime(usingRawTime: task.adjustedCountdownTime, usingMilliseconds: true)
    }
    
    // MARK: - Initialization
    
    init(withTask task: TimerTask) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
        modalTransitionStyle = .flipHorizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - Initial configuration & setup

extension TimerVC {
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        isModalInPresentation = true
    }
    
    private func configureDismissButton() {
        let config = UIHelpers.symbolConfig
        let dismissImage = UIImage(systemName: "multiply", withConfiguration: config)
        let dismissButton = UIBarButtonItem(image: dismissImage, style: .plain, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }
    
    private func configureProjectButton() {
        let config = UIHelpers.symbolConfig
        let projectImage = UIImage(systemName: "tv", withConfiguration: config)
        let projectButton = UIBarButtonItem(image: projectImage, style: .plain, target: self, action: #selector(projectScreen))
        navigationItem.leftBarButtonItem = projectButton
    }
    
    @objc private func projectScreen() {
        print("ProjectScreen button tapped")
    }
    
    private func configureDigitalDisplayLabel() {
        view.addSubview(digitalDisplayLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            digitalDisplayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            digitalDisplayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            digitalDisplayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            digitalDisplayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSecondaryDigitalDisplayLabel() {
        view.addSubview(secondaryDigitalDisplaylabel)
        secondaryDigitalDisplaylabel.textColor = .tertiaryLabel
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            secondaryDigitalDisplaylabel.topAnchor.constraint(equalTo: digitalDisplayLabel.bottomAnchor, constant: 10),
            secondaryDigitalDisplaylabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            secondaryDigitalDisplaylabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            secondaryDigitalDisplaylabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureStackViewButtons() {
        let stackView = UIStackView(arrangedSubviews: [decrementButton, resetButton, incrementButton])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            decrementButton.heightAnchor.constraint(equalTo: decrementButton.widthAnchor),
            incrementButton.heightAnchor.constraint(equalTo: incrementButton.widthAnchor),
            resetButton.heightAnchor.constraint(equalTo: resetButton.widthAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            decrementButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

    }
    
    @objc private func incrementButtonTapped() {
        print("increment button tapped")
        let timeInterval = Settings.shared.timeIncrement
        task.adjustCountdownTime(modifier: .increment, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateUI()
        }
    }
    
    @objc private func decrementButtonTapped() {
        print("decrement button tapped")
        let timeInterval = Settings.shared.timeIncrement
        task.adjustCountdownTime(modifier: .decrement, value: timeInterval) { [weak self] in
            guard let self = self else { return }
            self.updateButtonLabels(timeInterval: timeInterval)
            self.updateUI()
        }
    }
    
    private func updateButtonLabels(timeInterval: Double) {
        decrementButton.setTitle("-\(Int(timeInterval))s", for: .normal)
        incrementButton.setTitle("+\(Int(timeInterval))s", for: .normal)
    }
    
    @objc private func resetButtonTapped() {
        print("reset button tapped")
    }
    
    private func configurePrimaryActionButton() {
        view.addSubview(primaryActionButton)
        primaryActionButton.layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            primaryActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryActionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            primaryActionButton.heightAnchor.constraint(equalTo: primaryActionButton.widthAnchor),
            primaryActionButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
