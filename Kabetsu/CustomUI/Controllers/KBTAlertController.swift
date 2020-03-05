//
//  KBTAlertController.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit
import AudioToolbox

extension Notification.Name {
    static let alertDidDismiss = Notification.Name("alertDidDismiss")
}

class KBTAlertController: UIViewController {
    
    private var alertContainer: UIView!
    private var titleLabel: KBTTitleLabel!
    private var messageLabel: KBTBodyLabel?
    
    private var actionButton: KBTCircularButton!
    private var actionButtonDismissHandler: (() -> Void)?
    
    var prefersActionButtonHidden: Bool = false
    var tapBackgroundViewToDismiss: Bool = false
    
    private var constraints = KBTConstraints()
    
    init(withTitle title: String, message: String? = nil, onDismiss dismissHandler: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        self.titleLabel = KBTTitleLabel(text: title, textAlignment: .center)
        self.messageLabel = message != nil ? KBTBodyLabel(text: message!) : nil
        self.actionButtonDismissHandler = dismissHandler
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - VIEW CONTROLLER LIFECYCLE

extension KBTAlertController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureAlertContainer()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
        
        configureUniversalConstraints()
        updateConstraints()
    }
}


// MARK: - ACTIONS

extension KBTAlertController {
    @objc private func alertBackgroundViewTapped() {
        guard tapBackgroundViewToDismiss else { return }
        dismissController()
    }
    @objc private func dismissController() {
        if let actionButtonDismissHandler = actionButtonDismissHandler {
            actionButtonDismissHandler()
        }
        dismiss(animated: true)
    }
}


// MARK: - UI UPDATES

extension KBTAlertController {
    private func updateConstraints() {
        constraints.activate(.universal)
    }
}


// MARK: - CONFIGURATION

extension KBTAlertController {
    private func configureViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alertBackgroundViewTapped)))
    }
    private func configureAlertContainer() {
        alertContainer = UIView(frame: .zero)
        alertContainer.backgroundColor = .secondarySystemBackground
        alertContainer.layer.cornerRadius = 40
        alertContainer.layer.borderWidth = 6
        alertContainer.layer.borderColor = UIColor.systemGreen.cgColor
        alertContainer.clipsToBounds = true
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertContainer)
    }
    private func configureTitleLabel() {
        alertContainer.addSubview(titleLabel)
    }
    private func configureMessageLabel() {
        guard let messageLabel = messageLabel else { return }
        messageLabel.textAlignment = .center
        alertContainer.addSubview(messageLabel)
    }
    private func configureActionButton() {
        guard !prefersActionButtonHidden else { return }
        actionButton = KBTCircularButton(withTitle: "OK", fontSize: 20)
        actionButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        alertContainer.addSubview(actionButton)
    }
}


// MARK: - CONSTRAINTS

extension KBTAlertController {
    
    @discardableResult private func configureUniversalConstraints() -> [NSLayoutConstraint] {
        let titleVerticalPadding: CGFloat = 30
        let topInset: CGFloat = 15
        let bottomInset: CGFloat = 25
        let horizontalInset: CGFloat = 30
        
        let containerWidth = CGFloat.minimum(CGFloat.minimum(view.bounds.width, view.bounds.height) * 0.8, 500)
            
        var universalConstraints: [NSLayoutConstraint] = [
            alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainer.widthAnchor.constraint(equalToConstant: containerWidth),
            alertContainer.heightAnchor.constraint(equalTo: alertContainer.widthAnchor, multiplier: 0.8),
            
            titleLabel.leadingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInset),
            titleLabel.centerYAnchor.constraint(equalTo: alertContainer.centerYAnchor).withPriority(UILayoutPriority(rawValue: 960)),
            titleLabel.heightAnchor.constraint(equalTo: alertContainer.heightAnchor, multiplier: 0.2),
            titleLabel.topAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.topAnchor, constant: titleVerticalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.bottomAnchor, constant: -titleVerticalPadding).withPriority(UILayoutPriority(rawValue: 950))
        ]
        
        if let messageLabel = messageLabel {
            universalConstraints.append(contentsOf: [
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topInset),
                messageLabel.leadingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInset),
                messageLabel.trailingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInset),
                messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: alertContainer.safeAreaLayoutGuide.bottomAnchor, constant: titleVerticalPadding).withPriority(UILayoutPriority(rawValue: 960)),
            ])
        }
        
        if let actionButton = actionButton {
            universalConstraints.append(contentsOf: [
                actionButton.topAnchor.constraint(greaterThanOrEqualTo: messageLabel?.bottomAnchor ?? titleLabel.bottomAnchor, constant: topInset),
                actionButton.leadingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInset),
                actionButton.trailingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInset),
                actionButton.bottomAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.bottomAnchor, constant: -bottomInset),
                actionButton.heightAnchor.constraint(equalTo: alertContainer.heightAnchor, multiplier: 0.25)
            ])
        }
        constraints.append(forSizeClass: .universal, constraints: universalConstraints)
        return universalConstraints
    }
}
