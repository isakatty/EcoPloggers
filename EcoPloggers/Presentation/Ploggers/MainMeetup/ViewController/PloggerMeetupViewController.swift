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
        cv.backgroundColor = Constant.Color.white
        return cv
    }()
    private lazy var postBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.backgroundColor = Constant.Color.blueGreen
        btn.imageView?.clipsToBounds = true
        btn.tintColor = Constant.Color.white
        return btn
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MultiSectionModel>!
    
    private var headerTapEvent = PublishRelay<IndexPath>()
    private var headerText = PublishRelay<String>()
    
    override init() {
        super.init()
        
        configureDataSource()
        bind()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.searchTextField
        textField.subviews.first?.subviews.first?.removeFromSuperview()
        
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MultiSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .bannerSectionItem(let data):
                guard let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell
                else { return UICollectionViewCell() }
                cell.configureUI(count: String(indexPath.item + 1), img: UIImage(data: data))
                
                return cell
            case .regionSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.identifier, for: indexPath) as? RegionCollectionViewCell else { return UICollectionViewCell() }
                cell.configureLabel(regionName: data.toTitle)
                return cell
            case .favoriteSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.configureData(imageFilePath: data.files.first, creator: data.creator.nick, title: data.title, location: data.product_id)
                return cell
            case .latestSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.configureData(imageFilePath: data.files.first, creator: data.creator.nick, title: data.title, location: data.product_id)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, headerText, indexPath in
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            default:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                let section = dataSource.sectionModels[indexPath.section]
                header.configureUI(headerText: section.title, sectionNum: indexPath.section)
                
                header.clearBtn.rx.tap
                    .map { indexPath }
                    .bind(with: self) { owner, indexPath in
                        owner.headerTapEvent.accept(indexPath)
                        owner.headerText.accept(section.title)
                    }
                    .disposed(by: header.disposeBag)
                
                return header
            }
        })
        
    }
    private func bind() {
        let meetupCellTap = PublishRelay<ViewPostDetailResponse>()
        let regionCellTap = PublishRelay<Region>()
        let input = PloggersViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            headerTapEvent: headerTapEvent,
            headerText: headerText,
            meetupCellTap: meetupCellTap,
            regionCellTap: regionCellTap,
            plusBtnTap: postBtn.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.sections
            .bind(to: ploggingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: Cell Tap Event -> VM -> output -> View 이동
        // Detail VC에 likes2 버튼 넣어야함.
        Observable.zip(ploggingCollectionView.rx.modelSelected(SectionItem.self), ploggingCollectionView.rx.itemSelected)
            .bind { model, indexPath in
                switch model {
                case .bannerSectionItem(let data):
                    print(data, indexPath)
                case .regionSectionItem(let data):
                    regionCellTap.accept(data)
                case .favoriteSectionItem(let data), .latestSectionItem(let data):
                    meetupCellTap.accept(data)
                }
            }
            .disposed(by: disposeBag)

        Observable.zip(output.postRouter, output.naviTitle)
            .bind(with: self) { owner, arg1 in
                let vc = MeetupListViewController(viewModel: MeetupViewModel(router: arg1.0))
                vc.navigationItem.title = arg1.1
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.meetupCellTap
            .bind(with: self) { owner, response in
                let detailVM = MeetupDetailViewModel(detailPost: response)
                let vc = MeetupDetailViewController(viewModel: detailVM)
                vc.navigationItem.title = response.title
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.regionCellTap
            .bind(with: self) { owner, region in
                print(region.toTitle, "화면 이동 해야함.")
                let vc = SpecificRegionViewController(viewModel: .init(region: region))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.plusBtnTap
            .bind(with: self) { owner, _ in
                print("네?")
                let vc = PostMeetupViewController()
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        navigationItem.title = "🌿EcoPloggers🌿"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20 ?? UIFont.systemFont(ofSize: 20, weight: .medium)]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        [ploggingCollectionView, postBtn]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        ploggingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        postBtn.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.trailing.bottom.equalTo(safeArea).inset(18)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.postBtn.layer.cornerRadius = self.postBtn.bounds.height / 2
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
                return self.createFavoriteSectionLayout()
            case 3:
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
            heightDimension: .fractionalHeight(0.3)
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
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 4, bottom: 5, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.04)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 5, leading: 15, bottom: 15, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
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
            heightDimension: .fractionalHeight(0.42)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
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
            heightDimension: .absolute(35)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
