//
//  AddNewTimerVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/06.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

protocol AddNewTimerViewControllerDelegate: class {
    func didDismissAddNewTimerVC()
}

class AddNewTimerVC: UIViewController {
        
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    
    private let textLabel = UILabel()
    private let timePicker = UIPickerView()
    private var confirmBarButton: UIBarButtonItem!
    private var confirmButton: KBTButton!
    
    private let timersList = TimersList.shared
    private var constraints = Constraints()

    weak var delegate: AddNewTimerViewControllerDelegate!

    // MARK: Picker Components Enum
    private enum PickerComponents: Int, CaseIterable {
        case hours
        case hoursLabel
        case minutes
        case minutesLabel
        case seconds
        case secondsLabel
        
        var rowCount: Int {
            switch self {
            case .hours: return 24
            case .hoursLabel: return 1
            case .minutes: return 60
            case .minutesLabel: return 1
            case .seconds: return 12
            case .secondsLabel: return 1
            }
        }
        
        func rowTitle(forRow row: Int) -> String {
            switch self {
            case .hours:
                return "\(row)"
            case .hoursLabel:
                return "hrs"
            case .minutes:
                return "\(row)"
            case .minutesLabel:
                return "min"
            case .seconds:
                return "\(row * 5)"
            case .secondsLabel:
                return "sec"
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTextLabel()
        configureTimePicker()
        configureConfirmButtons()
        configureDismissButton()
        selectPickerRows()
        
        // Constraints
        configureConstraintsForRegular()
        configureConstraintsForVerticallyCompact()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        updateUI()
    }
    
    // MARK: AddNewTimerVC Functions
    private func getFormattedTextForDisplay() -> String {
        hours = timePicker.selectedRow(inComponent: PickerComponents.hours.rawValue)
        minutes = timePicker.selectedRow(inComponent: PickerComponents.minutes.rawValue)
        seconds = timePicker.selectedRow(inComponent: PickerComponents.seconds.rawValue) * 5
        
        let rawTime = TimerTask.getTimeIntervalFromTimeComponents(hours: hours, minutes: minutes, seconds: seconds)
        var formattedTextForDisplay = ""
        
        if timersList.timers.firstIndex(of: rawTime) == nil, rawTime != 0.0 {
            confirmBarButton.isEnabled = true
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = .systemGreen
            formattedTextForDisplay = getTimeFromPicker()
        } else {
            confirmBarButton.isEnabled = false
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = .systemGray
            formattedTextForDisplay = rawTime == 0.0 ? "Cannot create timer of 0 seconds" : "Time already in collection."
        }
        return formattedTextForDisplay
    }
    
    private func getTimeFromPicker() -> String {
        hours = timePicker.selectedRow(inComponent: PickerComponents.hours.rawValue)
        minutes = timePicker.selectedRow(inComponent: PickerComponents.minutes.rawValue)
        seconds = timePicker.selectedRow(inComponent: PickerComponents.seconds.rawValue) * 5
        
        var displayComponents = [String]()
        
        if hours != 0 {
            displayComponents.append("\(hours) hour(s)")
        }
        if minutes != 0 {
            displayComponents.append("\(minutes) minute(s)")
        }
        if seconds != 0 {
            displayComponents.append("\(seconds) seconds")
        }
        
        var displayText = ""
        for (index, item) in displayComponents.enumerated() {
            displayText += item
            if displayComponents.count != 1 {
                if index != displayComponents.count - 1 {
                    displayText += index != displayComponents.count - 2 ?  ", " : ", and "
                }
            }
        }
        return displayText
    }
    
    private func updateUI() {
        textLabel.text = getFormattedTextForDisplay()
    }
}



// MARK: - Get unique time

extension AddNewTimerVC {
    private func getUniqueTimeForPicker(time: TimeInterval) -> TimeInterval {
        guard time < DateInterval.timeInSecondsFor24hours - 60 else { return time }
        var time = time
        if timersList.timers.contains(time) {
             time = getUniqueTimeForPicker(time: time + 60)
        }
        return time
    }
    
    private func convertUnixTimeToTimeComponents(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: time)!
    }
    
    private func selectPickerRows() {
        let uniqueTime = getUniqueTimeForPicker(time: timersList.timers.last ?? 60)
        let timeString = convertUnixTimeToTimeComponents(time: uniqueTime)
        let timeComponents = timeString.components(separatedBy: ":")
        for (index, time) in timeComponents.enumerated() {
            let row = Int(time)!
            let component: PickerComponents
            switch index {
            case 0: component = PickerComponents.hours
            case 1: component = PickerComponents.minutes
            case 2: component = PickerComponents.seconds
            default:
                component = PickerComponents.hours
                fatalError("Error in producing picker component enum in AddNewTimerVC")
            }
            timePicker.selectRow(row, inComponent: component.rawValue, animated: false)
        }
    }
}



// MARK: - UIPickerView Delegate

extension AddNewTimerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerComponent = PickerComponents(rawValue: component)!
        let title = pickerComponent.rowTitle(forRow: row)
        let stringColorKey = NSAttributedString.Key.foregroundColor
        return NSAttributedString(string: title, attributes: [stringColorKey: UIColor.label])
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
        textLabel.layer.cornerRadius = 16
        textLabel.layer.borderWidth = 2
        textLabel.layer.borderColor = UIColor.white.cgColor
        textLabel.clipsToBounds = true
    }
    
    private func configureTimePicker() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.backgroundColor = .secondarySystemBackground
        timePicker.layer.cornerRadius = 16
        timePicker.layer.borderWidth = 2
        timePicker.layer.borderColor = UIColor.white.cgColor
        timePicker.clipsToBounds = true
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    
    private func configureConfirmButtons() {
        confirmBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirmButtonTapped))
        navigationItem.rightBarButtonItem = confirmBarButton

        confirmButton = KBTButton(withTitle: "Add Timer")
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        view.addSubview(confirmButton)
    }
    
    private func configureDismissButton() {
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissButtonTapped))
        navigationItem.leftBarButtonItem = dismissButton
    }
}



// MARK: - Button Actions

extension AddNewTimerVC {
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        let time = TimerTask.getTimeIntervalFromTimeComponents(hours: hours, minutes: minutes, seconds: seconds)
        if let delegate = delegate {
            timersList.timers.append(time)
            delegate.didDismissAddNewTimerVC()
            dismiss(animated: true)
        } else {
            print("Delegate for AddNewTimerVCDelegate has not been set.")
        }
    }
}


/*
 We need to think about how to properly do this. We can use UITraitCollection.device, however this can cause
 issues when a view is present that does not span the full width on the screen (e.g. ipads using popover controller
 or split view controller.
 
 A better way to do this is to use size classes. The documentation for UITraitCollection states various size classes what can
 be used to determine the width/height of the window/view.
 https://developer.apple.com/documentation/uikit/uitraitcollection
 
 We can access specific trait values using the horizontalSizeClass, verticalSizeClass, displayScale,
 and userInterfaceIdiom properties.
 */


// MARK: - Constraints

extension AddNewTimerVC {
    
    private var padding: CGFloat { return 20 }
    private var thickerPadding: CGFloat { return 40 }
    private var buttonHeight: CGFloat { return 70 }
    
    private func configureConstraintsForRegular() {
        let regularConstraints: [NSLayoutConstraint] = [
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textLabel.heightAnchor.constraint(equalToConstant: 100),
            
            timePicker.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  padding),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            timePicker.heightAnchor.constraint(equalToConstant: 200),
            
            confirmButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: padding),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ]
        //constraints.regular = regularConstraints
    }
    
    private func configureConstraintsForVerticallyCompact() {
        let verticallyCompactConstraints: [NSLayoutConstraint] = [
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            timePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            timePicker.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding),
            timePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: thickerPadding),
            textLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            textLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -padding),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -thickerPadding),
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ]
        constraints.verticallyCompact = verticallyCompactConstraints
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .compact {
            constraints.activate(.verticallyCompact)
            return
        }
        constraints.activate(.regular)
    }
}
