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
    private let postBtnTapEvent = PublishRelay<Void>()
    
    private lazy var profileCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(MyPageProfileCVCell.self, forCellWithReuseIdentifier: MyPageProfileCVCell.identifier)
        cv.register(EcoProfileCVCell.self, forCellWithReuseIdentifier: EcoProfileCVCell.identifier)
        cv.register(SegmentCVHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SegmentCVHeaderView.identifier)
        cv.backgroundColor = .mainBG
        return cv
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MyPageSectionModel>!
    
    override init() {
        super.init()
        
        configureDataSource()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20]
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MyPageSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .profileSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageProfileCVCell.identifier, for: indexPath) as? MyPageProfileCVCell else { return UICollectionViewCell() }
                cell.configureUI(profile: data)
                
                cell.postButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.postBtnTapEvent.accept(())
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            case .favoriteSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EcoProfileCVCell.identifier, for: indexPath) as? EcoProfileCVCell
                else { return UICollectionViewCell() }
                
//                cell.configureData(imageFilePath: data.files.first, creator: data.creator.nick, title: data.title, location: "영등포")
                cell.configureUI(filePath: data.files.first)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, headerText, indexPath in
            switch indexPath.section {
            case 1:
                guard let header: SegmentCVHeaderView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: SegmentCVHeaderView.identifier,
                    for: indexPath
                ) as? SegmentCVHeaderView else { return UICollectionReusableView() }
                
                
                return header
            default:
                return UICollectionReusableView()
            }
        })
    }
    
    private func bind() {
        let input = ProfileViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            postBtnTap: postBtnTapEvent
        )
        let output = viewModel.transform(input: input)
        
        output.profileData
            .bind(to: profileCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        profileCollectionView.rx.modelSelected(MyPageSectionItem.self)
            .bind { section in
                switch section {
                case .profileSectionItem(let data):
                    print(data)
                case .favoriteSectionItem(let data):
                    print(data)
                }
            }
            .disposed(by: disposeBag)
        
        output.userPosted
            .bind(with: self) { owner, posts in
                print(posts)

            }
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
            heightDimension: .fractionalHeight(0.22)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    /// Fav layout
    private func createFavoriteSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
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
