//
//  StopwatchLogCell.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/03/05.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit


class StopwatchLogCell: UICollectionViewCell {
    
    static let reuseId = "stopwatchLogCell"
    
    var counter: KBTDigitDisplayLabel!
    var title: KBTDigitDisplayLabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        counter = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .left)
        counter.font = UIFont(name: "HelveticaNeue-bold", size: 30)
        counter.textColor = KBTColors.secondaryLabel
        contentView.addSubview(counter)
        
        title = KBTDigitDisplayLabel(fontWeight: .bold, textAlignment: .center)
        title.font = UIFont(name: "HelveticaNeue-bold", size: 30)
        title.textColor = KBTColors.primaryLabel
        contentView.addSubview(title)

        let padding: CGFloat = 40
        NSLayoutConstraint.activate([
            counter.topAnchor.constraint(equalTo: contentView.topAnchor),
            counter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            counter.widthAnchor.constraint(equalToConstant: 20),
            
            title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor.constraint(equalTo: counter.trailingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            title.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
