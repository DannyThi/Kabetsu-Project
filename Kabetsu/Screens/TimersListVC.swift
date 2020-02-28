//
//  TimersListVC.swift
//  Kabetsu
//
//  Created by Hai Long Danny Thi on 2020/01/27.
//  Copyright © 2020 Hai Long Danny Thi. All rights reserved.
//

import UIKit

class TimersListVC: UIViewController {
    
    private enum Section: Int {
        case main
    }
    
    private enum SectionLayoutKind: Int, CaseIterable {
        case main
        func columnCount(for width: CGFloat) -> Int {
            var columnsForPortrait = 2
            var columnsForLandscape = 3
            var wideModeBreakPoint = 500
            
            let model = UIDevice.current.model
            switch model {
            case "iPhone":
                columnsForPortrait = 2
                columnsForLandscape = 3
                wideModeBreakPoint = 500
            case "iPad":
                columnsForPortrait = 3
                columnsForLandscape = 4
                wideModeBreakPoint = 1000
            default:
                break
            }
            
            let wideMode = width > CGFloat(wideModeBreakPoint)
            switch self {
            case .main:
                return wideMode ? columnsForLandscape : columnsForPortrait
            }
        }
    }
    
    private struct ImageKeys {
        static let addTimer = "plus.circle.fill"
        static let settings = "slider.horizontal.3"
    }
    
    private let timersList = TimersList.shared
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, TimeInterval>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, TimeInterval>!
    
    private func updateUI(animated: Bool = true) {
        snapshot = NSDiffableDataSourceSnapshot<Section, TimeInterval>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(timersList.timers)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}



// MARK: - VIEW CONTROLLER LIFECYCLE

extension TimersListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureBarButtonItems()
        configureCollectionView()
        configureDataSource()
        
        configureUniversalConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        updateUI(animated: false)
    }
}



// MARK: - UICOLLECTIONVIEW DELEGATE

extension TimersListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = TimerTask(withTotalTime: timersList.timers[indexPath.row])
        let timerVC = TimerVC(withTask: task)
        navigationController?.pushViewController(timerVC, animated: true)
        
//        let navCon = UINavigationController(rootViewController: timerVC)
//        if UIDevice.current.model == "iPad" {
//            navCon.modalPresentationStyle = .fullScreen
//            navCon.modalTransitionStyle = .crossDissolve
//        }
//        present(navCon, animated: true)
    }
}

// MARK: - ACTIONS

extension TimersListVC {
    @objc private func plusButtonTapped(sender: Any) {
        guard let sender = sender as? UIBarButtonItem else { return }
        let addNewTimerVC = AddNewTimerVC()
        addNewTimerVC.delegate = self
        let navCon = UINavigationController(rootViewController: addNewTimerVC)
        navCon.modalPresentationStyle = .popover
        let popOver = navCon.popoverPresentationController!
        popOver.barButtonItem = sender
        popOver.sourceView = self.view
        present(navCon, animated: true)
    }
    @objc private func settingsButtonTapped(sender: Any) {
        guard let sender = sender as? UIBarButtonItem else { return }
        let settingsVC = SettingsVC()
        let navCon = UINavigationController(rootViewController: settingsVC)
        navCon.modalPresentationStyle = .popover
        let popOver = navCon.popoverPresentationController!
        popOver.barButtonItem = sender
        popOver.sourceView = self.view
        present(navCon, animated: true)
    }
}

// MARK: - CONFIGURATION

extension TimersListVC {
    private func configureViewController() {
        title = "Timers"
        view.backgroundColor = .systemBackground
    }
    private func configureBarButtonItems() {
        let config = GlobalImageKeys.symbolConfig()
        let settingsImage = UIImage(systemName: ImageKeys.settings, withConfiguration: config)
        let plusImage = UIImage(systemName: ImageKeys.addTimer, withConfiguration: config)
        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        let plusBarButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButtonTapped(sender:)))
        navigationItem.rightBarButtonItems = [plusBarButton]
        navigationItem.leftBarButtonItems = [settingsBarButton]
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCompositionalFlowLayout())
        collectionView.register(TimerCell.self, forCellWithReuseIdentifier: TimerCell.reuseId)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func configureCompositionalFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let layoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            
            let columns = layoutKind.columnCount(for: layoutEnvironment.container.contentSize.width)
        
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, timeInterval) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimerCell.reuseId, for: indexPath) as! TimerCell
            cell.set(timeInterval: timeInterval, delegate: self)
            return cell
        }
    }
}

// MARK: - CONSTRAINTS

extension TimersListVC {
    private func configureUniversalConstraints() {
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}



// MARK: - TIMERCELL DELEGATE

extension TimersListVC: TimerCellDelegate {
    func didTapDeleteButton(identifier: Any) {
        guard let identifier = identifier as? TimeInterval else { return }
        deleteButtonTapped(identifier: identifier)
    }
    private func deleteButtonTapped(identifier: TimeInterval) {
        let title = "Remove Timer?"
        let message = "Would you like to remove this \(TimerTask.formattedTimeFrom(timeInterval: identifier, style: .brief)) timer?"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            let index = self.timersList.timers.firstIndex(of: identifier)!
            self.timersList.timers.remove(at: index)
            self.didDismissAddNewTimerVC()
        }
        UIHelpers.displayDefaultAlert(title: title, message: message, actions: [deleteAction, cancelAction])
    }
}



// MARK: - ADDNEWTIMERVC DELEGATE

extension TimersListVC: AddNewTimerViewControllerDelegate {
    func didDismissAddNewTimerVC() {
        updateUI()
    }
}

