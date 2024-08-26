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
    private let viewModel = ProfileViewModel()
    
    private lazy var profileCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(MyPageProfileCVCell.self, forCellWithReuseIdentifier: MyPageProfileCVCell.identifier)
        cv.register(PloggingClubCollectionViewCell.self, forCellWithReuseIdentifier: PloggingClubCollectionViewCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        cv.backgroundColor = .mainBG
        return cv
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MyPageSectionModel>!
    
    override init() {
        super.init()
        
        configureDataSource()
        bind()
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MyPageSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .profileSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageProfileCVCell.identifier, for: indexPath) as? MyPageProfileCVCell else { return UICollectionViewCell() }
                cell.configureUI(profile: data)
                return cell
            case .favoriteSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.configureData(imageFilePath: data.files.first, creator: data.creator.nick, title: data.title, location: "영등포")
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, headerText, indexPath in
            switch indexPath.section {
            case 1:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                let section = dataSource.sectionModels[indexPath.section]
                header.configureUI(headerText: section.title, sectionNum: indexPath.section)
                
//                header.clearBtn.rx.tap
//                    .map { indexPath }
//                    .bind(with: self) { owner, indexPath in
//                        owner.headerTapEvent.accept(indexPath)
//                        owner.headerText.accept(section.title)
//                    }
//                    .disposed(by: header.disposeBag)
                
                return header
            default:
                return UICollectionReusableView()
            }
        })
    }
    
    private func bind() {
        let input = ProfileViewModel.Input(viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in })
        let output = viewModel.transform(input: input)
        
        output.profileData
            .bind(to: profileCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(profileCollectionView)
    }
    override func configureLayout() {
        super.configureLayout()
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
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    /// Fav layout
    private func createFavoriteSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.45)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
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
