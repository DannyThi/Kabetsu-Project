//
//  SettingsVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/02/14.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

#warning("Convert to Collection View with Diffable Datasource")

class SettingsVC: UIViewController {
    
    private enum Section: Int, CaseIterable {
        case interfaceStyle, timeIncrements
        var rowCount: Int {
            switch self {
            case .interfaceStyle:
                return Settings.shared.interfaceStyleFollowsIOS ? 1 : 2
            case .timeIncrements:
                return 1
            }
        }
        var title: String {
            switch self {
            case .interfaceStyle:
                return "dark mode"
            case .timeIncrements:
                return "time increments for timer"
            }
        }
        var description: String {
            switch self {
            case .interfaceStyle:
                return "Set the theme of the app."
            case .timeIncrements:
                return "Adjusts the number of seconds added/removed for the +/- buttons on the timer screen."
            }
        }
    }

    private var settings = Settings.shared
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureDismissButton()
        configureTableView()
        configureConstraintsForUniversal()
    }
}



// MARK: - Actions

extension SettingsVC {
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}


// MARK: - UITableViewDatasource

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)!.rowCount
    }
}


// MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)
        switch section {
            
        case .interfaceStyle:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: InterfaceStyleTVCell.reuseId) as! InterfaceStyleTVCell
                cell.delegate = self
                cell.set(interfaceStyleFollowsIOS: settings.interfaceStyleFollowsIOS)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTVCell.reuseId) as! ThemeTVCell
                cell.set(selectedSegmentIndex: settings.interfaceStyle.rawValue)
                cell.delegate = self
                return cell
            default:
                fatalError("Extra cell in SettingsVC: tableview.darkmode.")
            }
            
        case .timeIncrements:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimerIncrementsTVCell.reuseId) as! TimerIncrementsTVCell
            cell.set(timeIncrements: settings.timerIncrementControlValues, selectedIndex: settings.timerIncrementControlSelectedIndex)
            cell.delegate = self
            return cell
            
        case .none:
            fatalError("Settings tableView error.")
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Section(rawValue: section)?.description
    }
}


// MARK: - CONFIGURATION

extension SettingsVC {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Settings"
        
    }
    private func configureDismissButton() {
        let dismissButton = UIBarButtonItem(image: GlobalImageKeys.dismiss.image,
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = dismissButton
    }
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(InterfaceStyleTVCell.self, forCellReuseIdentifier: InterfaceStyleTVCell.reuseId)
        tableView.register(ThemeTVCell.self, forCellReuseIdentifier: ThemeTVCell.reuseId)
        tableView.register(TimerIncrementsTVCell.self, forCellReuseIdentifier: TimerIncrementsTVCell.reuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}


// MARK: - CONSTRAINTS

extension SettingsVC {
    private func configureConstraintsForUniversal() {
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


// MARK: - INTERFACE STYLE TABLE VIEW CELL DELEGATE

#warning("TODO: Use diffable datasource for animation")
extension SettingsVC: InterfaceStyleTVCellDelegate {
    func interfaceFollowsIOSSwitchValueChanged(_ value: Bool) {
        settings.interfaceStyleFollowsIOS = value
        tableView.reloadData()
    }
}



// MARK: - THEME TABLE VIEW CELL DELEGATE

extension SettingsVC: ThemeTVCellDelegate {
    func themeSegmentControlValueChanged(_ segmentIndex: Int) {        
        settings.interfaceStyle = InterfaceStyle(rawValue: segmentIndex)
    }
}


// MARK: - TIMER INCREMENTS TABLE VIEW CELL DELEGATE

extension SettingsVC: TimerIncrementsTVCellDelegate {
    func timerIncrementsSegmentControlValueChanged(value: Int) {
        settings.timerIncrementControlSelectedIndex = value
    }
}


