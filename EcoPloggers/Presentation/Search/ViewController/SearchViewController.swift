//
//  SearchViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    
    private var viewModel = SearchViewModel()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
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
    private lazy var seenPostCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(SeenPostCVCell.self, forCellWithReuseIdentifier: SeenPostCVCell.identifier)
        cv.backgroundColor = Constant.Color.white
        return cv
    }()
    private let latestLB: PlainLabel = {
        let lb = PlainLabel(fontSize: Constant.Font.medium17, txtColor: Constant.Color.black.withAlphaComponent(0.8))
        lb.text = "최근 본 게시글"
        return lb
    }()
    
    override init() {
        super.init()
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationLeftBar(action: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.searchTextField
        textField.subviews.first?.subviews.first?.removeFromSuperview()
        
    }
    
    private func bind() {
        let input = SearchViewModel.Input(viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in })
        let output = viewModel.transform(input: input)
        
        output.postLists
            .bind(to: seenPostCV.rx.items(cellIdentifier: SeenPostCVCell.identifier, cellType: SeenPostCVCell.self)) { row, element, cell in
                cell.configureUI(filePath: element.files.first, title: element.title, category: element.product_id)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(coverView)
        [latestLB, seenPostCV]
            .forEach { coverView.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        navigationItem.title = "Search"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20 ?? UIFont.systemFont(ofSize: 20, weight: .medium)]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        coverView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        latestLB.snp.makeConstraints { make in
            make.top.equalTo(coverView).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        latestLB.backgroundColor = Constant.Color.white
        seenPostCV.snp.makeConstraints { make in
            make.top.equalTo(latestLB.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
}
extension SearchViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .fractionalHeight(0.6)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return UICollectionViewCompositionalLayout(section: section)
    }
}
