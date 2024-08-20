//
//  TestViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

struct MainDataSection {
    var header: String
    var items: [ViewPostDetailResponse]
}

extension MainDataSection: SectionModelType {
    typealias Item = ViewPostDetailResponse
    
    init(original: MainDataSection, items: [ViewPostDetailResponse]) {
        self = original
        self.items = items
    }
}

final class TestViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let viewModel = TestViewModel()
    
    private let searchView = SearchView()
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
    private lazy var regionCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: regionLayout())
        cv.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        cv.backgroundColor = Constant.Color.mainBG
        return cv
    }()
    private lazy var ploggingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        cv.register(PloggingClubCollectionViewCell.self, forCellWithReuseIdentifier: PloggingClubCollectionViewCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        cv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cv.layer.cornerRadius = 40
        return cv
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MainDataSection>!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.searchTextField
        textField.subviews.first?.subviews.first?.removeFromSuperview()
    }
    
    func bind() {
        let input = TestViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.sectionData
            .bind(to: ploggingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.regions
            .bind(to: regionCollectionView.rx.items(cellIdentifier: RegionCollectionViewCell.identifier, cellType: RegionCollectionViewCell.self)) { row, element, cell in
                cell.configureLabel(regionName: element.rawValue)
            }
            .disposed(by: disposeBag)
        
        ploggingCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("Item selected at \(indexPath)")
            })
            .disposed(by: disposeBag)
    }
    func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MainDataSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                guard let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.configureUI(count: String(indexPath.item + 1), img: UIImage(systemName: "star.fill"))
                return cell
            case 1, 2:
                guard let cell: PloggingClubCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureUI(imageFile: UIImage(systemName: "star.fill"), creator: item.creator.nick, title: item.title, location: "문래")
                
                return cell
            default:
                guard let cell: PloggingClubCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureUI(imageFile: UIImage(systemName: "star.fill"), creator: item.creator.nick, title: item.title, location: "문래")
                
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, headerText, indexPath in
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1,2:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                header.configureUI(headerText: "지금 뜨는 플로깅 모임")
                return header
            default:
                return UICollectionReusableView()
            }
        })
    }
    
    override func configureHierarchy() {
        navigationItem.title = "🌿EcoPloggers🌿"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        [regionCollectionView, ploggingCollectionView]
            .forEach { view.addSubview($0) }
        
    }
    override func configureLayout() {
        super.configureLayout()
        regionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea).inset(10)
            make.trailing.equalTo(safeArea)
            make.height.equalTo(50)
        }
        ploggingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(regionCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
}

extension TestViewController {
    private func configureCVLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createFirstSectionLayout()
            case 1, 2:
                return self.createSecondSectionLayout()
            default:
                return self.createFirstSectionLayout()
            }
        }
        return layout
    }
    private func createFirstSectionLayout() -> NSCollectionLayoutSection {
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

    private func createSecondSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
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
    private func regionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.1),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = .init(leading: .fixed(10), top: .fixed(0), trailing: .fixed(10), bottom: .fixed(0))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.8)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }
}
