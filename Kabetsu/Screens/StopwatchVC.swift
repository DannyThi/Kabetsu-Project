//
//  StopwatchVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/05.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class StopwatchVC: UIViewController {
    

}

// MARK: ACTIONS

extension StopwatchVC {
    
    private func someFunc() {
        
    }
}

// MARK: VIEW CONTROLLER LIFECYCLE

extension StopwatchVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}


// MARK: CONFIGURATION

extension StopwatchVC {
    
    private func configureViewController() {
        view.backgroundColor = .systemPink
        self.title = "Stopwatch"
    }
}
