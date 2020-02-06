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
    
    private let timersList = TimersList.shared
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, TimeInterval>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, TimeInterval>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureBarButtonItems()

        configureCollectionView()
        configureDataSource()
        
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - CollectionView Configuration

extension TimersListVC {
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
}

// MARK: - CollectionView DataSource

extension TimersListVC {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, timeInterval) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimerCell.reuseId, for: indexPath) as! TimerCell
            cell.set(timeInterval: timeInterval, delegate: self)
            return cell
        }
    }
    
    private func updateUI(animated: Bool = true) {
        snapshot = NSDiffableDataSourceSnapshot<Section, TimeInterval>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(timersList.timers)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}


// MARK: - UICollectionView Delegate

extension TimersListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = TimerTask(withTotalTime: timersList.timers[indexPath.row])
        let timerVC = TimerVC(withTask: task)
        let navCon = UINavigationController(rootViewController: timerVC)
        if UIDevice.current.model == "iPad" {
            navCon.modalPresentationStyle = .fullScreen
            navCon.modalTransitionStyle = .crossDissolve
        }
        present(navCon, animated: true)
    }
}



// MARK: - Initial configuration & setup

extension TimersListVC {
    private func configureViewController() {
        title = "Timers"
        view.backgroundColor = .systemBackground
    }
    
    private func configureBarButtonItems() {
        let config = UIHelpers.symbolConfig
        
        let settingsImage = UIImage(systemName: "gear", withConfiguration: config)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)

        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(settingsButtonTapped))
        let plusBarButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButtonTapped))

        navigationItem.rightBarButtonItems = [plusBarButton]
        navigationItem.leftBarButtonItems = [settingsBarButton]
    }
    
    @objc private func plusButtonTapped() {
        let addNewTimerVC = AddNewTimerVC()
        navigationController?.pushViewController(addNewTimerVC, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        print("Trash button tapped")
    }
}

extension TimersListVC: TimerCellButtonActionDelegate {
    
    func performDelegatedAction(identifier: Any) {
        guard let identifier = identifier as? TimeInterval else { return }
        deleteButtonTapped(identifier: identifier)
    }
    
    private func deleteButtonTapped(identifier: TimeInterval) {
        let title = "Remove this timer?"
        let message = "Do you want to remove timer: \(identifier)?"
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            let index = self.timersList.timers.firstIndex(of: identifier)!
            self.timersList.timers.remove(at: index)
            self.updateUI()
        }
        UIHelpers.displayDefaultAlert(title: title, message: message, actions: [deleteAction, cancelAction])
    }
}

