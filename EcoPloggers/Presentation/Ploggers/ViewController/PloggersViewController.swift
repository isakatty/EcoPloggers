//
//  PloggersViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class PloggersViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let viewModel = PloggersViewModel()
    
    private let ploggingSearchBar = SearchView()
    private lazy var regionCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: regionLayout())
        cv.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        cv.backgroundColor = Constant.Color.mainBG
        return cv
    }()
    private let vScrollView = UIScrollView()
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
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = Constant.Color.mainBG
        return view
    }()
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 40
        view.backgroundColor = Constant.Color.white
        return view
    }()
    private lazy var bannerCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: bannerLayout())
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        cv.layer.cornerRadius = 25
        return cv
    }()
    private let rizingContents = ContentsView()
    private let regionContents = ContentsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.searchTextField
        textField.subviews.first?.subviews.first?.removeFromSuperview()
    }
    
    private func bind() {
        let input = PloggersViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.regions
            .observe(on: MainScheduler.instance)
            .bind(to: regionCollectionView.rx.items(cellIdentifier: RegionCollectionViewCell.identifier, cellType: RegionCollectionViewCell.self)) { row, element, cell in
                cell.configureSelectedBar(isSelected: false)
                cell.configureLabel(regionName: element.rawValue)
            }
            .disposed(by: disposeBag)
        
        regionCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                print(indexPath, "되어야지 ^^")
            }
            .disposed(by: disposeBag)
        
        let bannerImgs = BehaviorRelay<[UIImage?]>(value: [UIImage(systemName: "star.fill"), UIImage(systemName: "star.fill"), UIImage(systemName: "star.fill"), UIImage(systemName: "star.fill"), UIImage(systemName: "star.fill")])
        
        bannerImgs
            .observe(on: MainScheduler.instance)
            .bind(to: bannerCollectionView.rx.items(cellIdentifier: BannerCollectionViewCell.identifier, cellType: BannerCollectionViewCell.self)) { row, element, cell in
                cell.configureUI(count: String(row + 1), img: element)
            }
            .disposed(by: disposeBag)
        
        bannerCollectionView.rx.itemSelected
            .debug("네?")
            .bind(with: self) { owner, indexPath in
                print(indexPath, "여기도 안되나 설마?")
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidBeginEditing
            .bind(with: self) { owner, _ in
                let vc = TestViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        navigationItem.title = "🌿EcoPloggers🌿"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        [bannerCollectionView, rizingContents, regionContents]
            .forEach { bottomContainerView.addSubview($0)}
        
        [regionCollectionView, bottomContainerView]
            .forEach { containerView.addSubview($0) }
        
        vScrollView.addSubview(containerView)
        
        [vScrollView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        vScrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(vScrollView.snp.width)
            make.verticalEdges.equalTo(vScrollView)
        }
        regionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(50)
        }
        bottomContainerView.snp.makeConstraints { make in
            make.top.equalTo(regionCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(containerView)
        }
        bannerCollectionView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(bottomContainerView).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(170)
        }
        rizingContents.snp.makeConstraints { make in
            make.top.equalTo(bannerCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
        }
        regionContents.snp.makeConstraints { make in
            make.top.equalTo(rizingContents.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
            make.bottom.equalTo(bottomContainerView.snp.bottom).inset(20)
        }
    }
    
}
extension PloggersViewController {
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
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
    private func bannerLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }
}
