//
//  KBTDigitDisplayLabel.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Spawn Camping Panda. All rights reserved.
//

import UIKit

class KBTDigitDisplayLabel: UILabel {
        
    func setTime(usingRawTime time: TimeInterval, usingMilliseconds milliseconds: Bool = false) {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        var formattedTime = formatter.string(from: time)!
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
        baselineAdjustment = .alignCenters
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.001
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        //debugMode()
    }
    
    private func debugMode() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
}
