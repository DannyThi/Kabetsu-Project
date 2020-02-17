//
//  KBTAlertController.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/17.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class KBTAlertController: UIViewController {
    
    private var alertContainer: UIView!
    private var titleLabel: KBTTitleLabel!
    private var messageLabel: KBTBodyLabel?
    
    private var actionButton: UIButton?
    private var actionButtonDismissHandler: (() -> Void)?
    
    var prefersActionButtonHidden: Bool = false
    
    private var constraints = KBTConstraints()
    
    init(withTitle title: String, message: String?, onDismiss dismissHandler: (() -> Void)? = nil) {
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
        
        configureUniversalConstraints()
        updateConstraints()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
}


// MARK: - ACTIONS

extension KBTAlertController {
    @objc private func dismissController() {
        dismiss(animated: true)
    }
}


// MARK: - UI UPDATES

extension KBTAlertController {
    private func updateConstraints() {
        #warning("FIX CONSTRAINTS UPDATE LATER")
        constraints.activate(.universal)
    }
}


// MARK: - CONFIGURATION

extension KBTAlertController {
    private func configureViewController() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
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
        alertContainer.addSubview(messageLabel)
    }
    
}


// MARK: - CONSTRAINTS

extension KBTAlertController {
    
    @discardableResult private func configureUniversalConstraints() -> [NSLayoutConstraint] {
        let verticalPadding: CGFloat = 0
        let horizontalPadding: CGFloat = 8
        
        // Set a width and height based on the size on the screen.
        // set the width to be x% of the height of the device bounds.
        // set the height to be x% of the width.
        // this way, regardless of the orientation, the width of thr alert will be longer than the height.
        
        // we can leave out constraints for the container because we are animating it in and out.
        // for now we add it so we can test
        var universalConstraints: [NSLayoutConstraint] = [
            alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainer.widthAnchor.constraint(equalToConstant: 300),
            alertContainer.heightAnchor.constraint(equalTo: alertContainer.widthAnchor, multiplier: 0.6),
            
            titleLabel.centerXAnchor.constraint(equalTo: alertContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: alertContainer.centerYAnchor).withPriority(UILayoutPriority(rawValue: 999)),
            titleLabel.widthAnchor.constraint(equalTo: alertContainer.widthAnchor, multiplier: 0.3),
            titleLabel.topAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding).withPriority(UILayoutPriority(rawValue: 991))
        ]
        
        if let messageLabel = messageLabel {
            universalConstraints.append(contentsOf: [
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalPadding),
                messageLabel.leadingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
                messageLabel.trailingAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
                messageLabel.bottomAnchor.constraint(equalTo: alertContainer.safeAreaLayoutGuide.bottomAnchor, constant: verticalPadding).withPriority(UILayoutPriority(rawValue: 990))
            ])
        }
        
        constraints.append(forSizeClass: .universal, constraints: universalConstraints)
        return universalConstraints
    }
    @discardableResult private func configureIPadAndExternalDisplayConstraints() -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            
        ]
        return constraints
    }
    

}
