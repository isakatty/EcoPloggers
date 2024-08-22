//
//  PloggerMeetupViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/22/24.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit

final class PloggerMeetupViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private var viewModel = PloggersViewModel()
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "지역을 검색해보세요."
        search.searchBar.sizeToFit()
        search.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        let searchTextField = search.searchBar.searchTextField
        searchTextField.backgroundColor = Constant.Color.clear
        searchTextField.clipsToBounds = true
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = Constant.Color.black.withAlphaComponent(0.5).cgColor
        searchTextField.layer.cornerRadius = 18
        return search
    }()
    private lazy var ploggingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        cv.register(PloggingClubCollectionViewCell.self, forCellWithReuseIdentifier: PloggingClubCollectionViewCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        cv.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        cv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cv.layer.cornerRadius = 40
        return cv
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MultiSectionModel>!
    
    override init() {
        super.init()
        
//        bind()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.searchTextField
        textField.subviews.first?.subviews.first?.removeFromSuperview()
        
        configureDataSource()
        bind()
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MultiSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                guard let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.configureUI(count: String(indexPath.item + 1), img: UIImage(systemName: "star.fill"))
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.identifier, for: indexPath) as? RegionCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureLabel(regionName: "서울")
                
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell else { return UICollectionViewCell() }
                cell.configureUI(imageFile: UIImage(systemName: "person.fill"), creator: "수윤", title: "영등포구청", location: "영등포 구청")
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, headerText, indexPath in
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            default:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                header.configureUI(headerText: "지금 뜨는 플로깅 모임")
                return header
            }
        })
        
    }
    private func bind() {
        let input = PloggersViewModel.Input(viewWillAppear: rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.sections
            .debug("VC - Sections")
            .bind(to: ploggingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        navigationItem.title = "🌿EcoPloggers🌿"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20 ?? UIFont.systemFont(ofSize: 20, weight: .medium)]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        [ploggingCollectionView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        ploggingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
}

extension PloggerMeetupViewController {
    private func configureCVLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createBannerSectionLayout()
            case 1:
                return self.createRegionSectionLayout()
            case 2:
                return self.createRegionSectionLayout()
            case 3:
                return self.createFavoriteSectionLayout()
            case 4:
                return self.createLatestSectionLayout()
            default:
                return self.createBannerSectionLayout()
            }
        }
        return layout
    }
    /// 배너 layout
    private func createBannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.27)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        return section
    }
    /// 지역 layout
    private func createRegionSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 10, leading: 15, bottom: 10, trailing: 15)
        return section
    }
    /// 기본 Cell layout
    private func createFavoriteSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.38)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 10, leading: 15, bottom: 10, trailing: 15)
        return section
    }
    private func createLatestSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 10, leading: 15, bottom: 10, trailing: 15)
        return section
    }

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
