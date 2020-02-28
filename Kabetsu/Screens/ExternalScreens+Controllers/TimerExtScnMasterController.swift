//
//  TimerExtScnMasterController.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/21.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerExtScnMasterController: UIViewController, TimerExtScnDetailsControllerDelegate {
    
    var task: TimerTask!
    
    private let constraints = KBTConstraints()
    private let settings = Settings.shared
    
    private var digitalDisplayLabel: KBTDigitDisplayLabel!
    private var secondaryDigitalDisplaylabel: KBTDigitDisplayLabel!
    private var labelContainer: UIStackView!
    
    private var primaryActionButton: KBTCircularButton!
    private var resetButton: KBTButton!
    private var buttonContainer: UIStackView!
    
    private var decrementButton: KBTButton!
    private var incrementButton: KBTButton!
    private var adjustmentsContainer: UIStackView!

    private var toolBar: UIToolbar!
    private var timerIncrementControl: UISegmentedControl!
    

    
    init(withTask task: TimerTask) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: VIEW CONTROLLER LIFECYCLE

extension TimerExtScnMasterController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .landscape : .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
//        configureToolBar()
//        configureDigitalDisplayLabel()
//        configureSecondaryDigitalDisplayLabel()
        // set up a link and delegate to the external display
        
        test()
        
    }
    
    private func test() {
        print("Testing...")
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        let button = KBTButton(withSFSymbolName: GlobalImageKeys.dismiss.rawValue)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),

            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }

}

// MARK: CONFIGURATION

extension TimerExtScnMasterController {
    
    private func configureViewController() {
        view.backgroundColor = .systemPink
        //view.backgroundColor = .systemBackground
    }
    private func configureToolBar() {
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
    }
    private func configureDigitalDisplayLabel() {
        digitalDisplayLabel = KBTDigitDisplayLabel(withFontSize: 500, fontWeight: .bold, textAlignment: .center)
        view.addSubview(digitalDisplayLabel)
    }
    private func configureSecondaryDigitalDisplayLabel() {
        secondaryDigitalDisplaylabel = KBTDigitDisplayLabel(withFontSize: 400, fontWeight: .bold, textAlignment: .center)
        secondaryDigitalDisplaylabel.textColor = .tertiaryLabel
        view.addSubview(secondaryDigitalDisplaylabel)
    }
}
// MARK: CONSTRAINTS

extension TimerExtScnMasterController {
    
    private func configureConstraints() {
        
    }
}


