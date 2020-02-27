//
//  TimerControlsVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/21.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimerControlsVC: UIViewController {
    
    var task: TimerTask!
    private let constraints = KBTConstraints()
    private let settings = Settings.shared
    
//    private var digitalDisplayLabel: KBTDigitalDisplayLabel!
//    private var secondaryDigitalDisplaylabel: KBTDigitalDisplayLabel!
//    private var labelContainer: UIStackView!
    
    private var primaryActionButton: KBTCircularButton!
    private var resetButton: KBTButton!
    private var buttonContainer: UIStackView!
    
    private var decrementButton: KBTButton!
    private var incrementButton: KBTButton!
    private var adjustmentsContainer: UIStackView!

    private var toolBar: UIToolbar!
    private var timerIncrementControl: UISegmentedControl!
    
    //private let buttonImagePointSize: CGFloat = 80
    
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

extension TimerControlsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up a link and delegate to the external display
        
        
    }
}

