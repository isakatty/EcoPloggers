//
//  MyPageViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit

final class MyPageViewController: BaseViewController {
    private let disposeBag = DisposeBag()
//    private let viewModel = Profil
    
    private lazy var profileCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(MyPageProfileCVCell.self, forCellWithReuseIdentifier: MyPageProfileCVCell.identifier)
        cv.register(ProfileDetailInfoCVCell.self, forCellWithReuseIdentifier: ProfileDetailInfoCVCell.identifier)
        cv.register(LatestCollectionViewCell.self, forCellWithReuseIdentifier: LatestCollectionViewCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        return cv
    }()
    
    private let dataSource: RxCollectionViewSectionedReloadDataSource<>!
    
    private func configureDataSource() {
        
    }
    
    private func bind() {
        
    }
    
    override func configureHierarchy() {
        view.addSubview(profileCollectionView)
    }
    override func configureLayout() {
        profileCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
}
extension MyPageViewController {
    private func configureCVLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createProfileSectionLayout()
            case 1:
                return self.createDetailSectionLayout()
            case 2:
                return self.createFavoriteSectionLayout()
            default:
                return self.createFavoriteSectionLayout()
            }
        }
        return layout
    }
    /// Profile layout
    private func createProfileSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    /// Post Detail layout
    private func createDetailSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 4, bottom: 5, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    /// Fav layout
    private func createFavoriteSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    /// Header layout
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
