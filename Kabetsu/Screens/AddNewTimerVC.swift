//
//  AddNewTimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/06.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class AddNewTimerVC: UIViewController {
    
    private var textLabel = UILabel()
    private var timePicker = UIPickerView()
    private var timersList = TimersList.shared
    
    
    private enum PickerComponents: Int, CaseIterable {
        case hours
        case hoursLabel
        case minutes
        case minutesLabel
        case seconds
        case secondsLabel
        
        var rowCount: Int {
            switch self {
            case .hours: return 12
            case .hoursLabel: return 1
            case .minutes: return 60
            case .minutesLabel: return 1
            case .seconds: return 60
            case .secondsLabel: return 1
            }
        }
        
        func rowTitle(forRow row: Int) -> String {
            switch self {
            case .hours:
                return "12"
            case .hoursLabel:
                return "hrs"
            case .minutes:
                return "60"
            case .minutesLabel:
                return "min"
            case .seconds:
                return "60"
            case .secondsLabel:
                return "sec"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTextLabel()
        configureTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - UIPickerView Delegate

extension AddNewTimerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //checkForValidity()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerComponent = PickerComponents(rawValue: component)!
        
        let title = pickerComponent.rowTitle(forRow: row)

        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        return attributedTitle
    }
}


// MARK: - UIPickerView Datasource

extension AddNewTimerVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PickerComponents.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerComponent = PickerComponents(rawValue: component)!
        return pickerComponent.rowCount
    }
    
    
}

// MARK: - Configuration

extension AddNewTimerVC {
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Add New Timer"
    }
    
    private func configureTextLabel() {
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.textAlignment = .center
        textLabel.textColor = .label
        textLabel.backgroundColor = .secondarySystemBackground
        textLabel.numberOfLines = 2
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.8
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.text = "Lots of text. So much text it spans tow rows!"
        textLabel.layer.cornerRadius = 16
        textLabel.layer.borderWidth = 2
        textLabel.layer.borderColor = UIColor.white.cgColor
        textLabel.clipsToBounds = true
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTimePicker() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.delegate = self
        timePicker.dataSource = self
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: padding),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  padding),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            timePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
