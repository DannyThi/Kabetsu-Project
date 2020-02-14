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
        configureIPhonePortraitConstraints()
        configureIPhoneLandscapeRegularConstraints()
        
        updateConstraints()

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
        textLabel.layer.cornerRadius = UIHelpers.cornerRadius
        textLabel.layer.borderWidth = UIHelpers.borderWidth
        textLabel.layer.borderColor = UIColor.white.cgColor
        textLabel.clipsToBounds = true
    }
    
    private func configureTimePicker() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.backgroundColor = .secondarySystemBackground
        timePicker.layer.cornerRadius = UIHelpers.cornerRadius
        timePicker.layer.borderWidth = UIHelpers.borderWidth
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



// MARK: - Constraints

extension AddNewTimerVC {
    
//    private var padding: CGFloat { return 20 }
//    private var thickerPadding: CGFloat { return 40 }
//    private var buttonHeight: CGFloat { return 70 }
//
    private func configureIPhonePortraitConstraints() {
        let verticalPadding: CGFloat = 15
        let horizontalPadding: CGFloat = 20
        let buttonHeight: CGFloat = 50
        
        let iPhonePortraitConstraints: [NSLayoutConstraint] = [
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            textLabel.heightAnchor.constraint(equalToConstant: 100),
            
            timePicker.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  horizontalPadding),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            timePicker.heightAnchor.constraint(equalToConstant: 200),
            
            confirmButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: verticalPadding),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ]
        constraints.iPhonePortrait = iPhonePortraitConstraints
    }
    
    private func configureIPhoneLandscapeRegularConstraints() {
        let verticalPadding: CGFloat = 30
        let horizontalPadding: CGFloat = 10
        let buttonHeight: CGFloat = 50
        
        let iPhoneLandscapeRegularConstraints: [NSLayoutConstraint] = [
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            timePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            timePicker.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -horizontalPadding),
            timePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),

            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
            textLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: horizontalPadding),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            textLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -verticalPadding),

            confirmButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: horizontalPadding),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding),
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ]
        constraints.iPhoneLandscapeRegular = iPhoneLandscapeRegularConstraints
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
    
    private func updateConstraints() {
        if traitCollection.verticalSizeClass == .compact {
            constraints.activate(.iPhoneLandscapeRegular)
            return
        }
        constraints.activate(.iPhonePortrait)
    }
}
