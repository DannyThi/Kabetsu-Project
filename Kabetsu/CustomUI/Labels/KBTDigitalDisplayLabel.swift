//
//  KBTDigitalDisplayLabel.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Spawn Camping Panda. All rights reserved.
//

import UIKit

class KBTDigitalDisplayLabel: UILabel {
        
    func setTime(usingRawTime time: TimeInterval, usingMilliseconds milliseconds: Bool = false) {
        let timeAsInt = Int(time)
        let seconds = timeAsInt % 60
        let minutes = (timeAsInt / 60) % 60
        let hours = timeAsInt / 3600
        
        var formattedTime = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        if milliseconds {
            let milliseconds = Int(time.truncatingRemainder(dividingBy: 1) * 100)
            formattedTime += String(format: ":%02i", milliseconds)
        }
        self.text = formattedTime
    }
    
    
    // MARK: - Initialization
    
    init(withFontSize fontSize: CGFloat, fontWeight: UIFont.Weight = .medium, textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: fontWeight)
        self.textAlignment = textAlignment
        configureLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
