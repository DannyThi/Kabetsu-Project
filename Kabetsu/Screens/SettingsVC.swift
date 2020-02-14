//
//  SettingsVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/14.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

// Settings should display modally on iphone and pop over on ipad.

class SettingsVC: UIViewController {
    
    private var settings = Settings.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
}
