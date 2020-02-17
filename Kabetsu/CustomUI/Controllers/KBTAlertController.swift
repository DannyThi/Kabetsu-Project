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
    private var messageLabel: UILabel!
    private var actionButton: UIButton!
    
    private var constraints: KBTConstraints!
    
    init(withTitle title: String, message: String?, onDismiss dismissHandler: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
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

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
    }
}


// MARK: - ACTIONS

extension KBTAlertController {
    @objc private func dismissController() {
        dismiss(animated: true)
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
        alertContainer.backgroundColor = .systemBackground
        alertContainer.layer.cornerRadius = 25
        alertContainer.layer.borderWidth = 2
        alertContainer.layer.borderColor = UIColor.systemGreen.cgColor
        alertContainer.clipsToBounds = true
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertContainer)
    }
    
}


// MARK: - CONSTRAINTS

extension KBTAlertController {
    private func configureUniversalConstraints() -> [NSLayoutConstraint] {
        
        let constraints: [NSLayoutConstraint] = [
            // Set a width and height based on the size on the screen.
            // set the width to be x% of the height of the device bounds.
            // set the height to be x% of the width.
            // this way, regardless of the orientation, the width of thr alert will be longer than the height.
            
            // we can leave out constraints for the container because we are animating it in and out.
            // for now we add it so we can test
            
            alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainer.widthAnchor.constraint(equalToConstant: 800),
            alertContainer.heightAnchor.constraint(equalTo: alertContainer.widthAnchor, multiplier: 0.6)
        ]
        return constraints
    }
    private func configureIPadAndExternalDisplayConstraints() -> [NSLayoutConstraint] {
        
        let constraints: [NSLayoutConstraint] = [
            
        ]
        return constraints
    }
    

}
