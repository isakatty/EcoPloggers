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
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 40
        view.backgroundColor = Constant.Color.white
        return view
    }()
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "person.fill")
        return img
    }()
    private let textLabels: UILabel = {
        let label = UILabel()
        label.text = "하이루"
        label.backgroundColor = Constant.Color.white
        return label
    }()
    private let rizingContents = ContentsView()
    private let regionContents = ContentsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
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
        
        Observable.zip(regionCollectionView.rx.itemSelected, regionCollectionView.rx.modelSelected(Region.self))
            .debug("Selected item")
            .subscribe(onNext: { indexPath, region in
                print("Item selected at: \(indexPath), region: \(region.rawValue)")
            })
            .disposed(by: disposeBag)
    }
    override func configureHierarchy() {
        [textLabels, rizingContents, regionContents]
            .forEach { containerView.addSubview($0) }
        
        vScrollView.addSubview(containerView)
        
        [ploggingSearchBar, regionCollectionView, vScrollView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        ploggingSearchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(44)
        }
        regionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ploggingSearchBar.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(50)
        }
        vScrollView.snp.makeConstraints { make in
            make.top.equalTo(regionCollectionView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalTo(vScrollView.snp.width)
            make.verticalEdges.equalTo(vScrollView)
        }
        textLabels.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(containerView)
            make.height.equalTo(300)
        }
        rizingContents.snp.makeConstraints { make in
            make.top.equalTo(textLabels.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
        }
        regionContents.snp.makeConstraints { make in
            make.top.equalTo(rizingContents.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea)
            make.bottom.equalTo(containerView.snp.bottom).inset(20)
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
}
