//
//  SpecificRegionViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SpecificRegionViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SpecificRegionViewModel
    
    private lazy var categoryCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout())
        cv.register(
            BoroughCVCell.self,
            forCellWithReuseIdentifier: BoroughCVCell.identifier
        )
        cv.backgroundColor = Constant.Color.white
        return cv
    }()
    private lazy var regionCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.backgroundColor = Constant.Color.mainBG
        cv.register(MeetupListCollectionViewCell.self, forCellWithReuseIdentifier: MeetupListCollectionViewCell.identifier)
        return cv
    }()
    
    init(viewModel: SpecificRegionViewModel) {
        self.viewModel = viewModel
        super.init()
        
        bind()
    }
    
    override func configureHierarchy() {
        [categoryCV, regionCV]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
//        super.configureLayout()
        configureNavigationLeftBar(action: nil)
        view.backgroundColor = Constant.Color.white
        
        categoryCV.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(40)
        }
        regionCV.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.top.equalTo(categoryCV.snp.bottom)
        }
    }
    private func bind() {
        let cellTapEvent = PublishRelay<ViewPostDetailResponse>()
        let input = SpecificRegionViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            cellTapEvent: cellTapEvent
        )
        let output = viewModel.transform(input: input)
        
        output.categoryRegion
            .bind(to: categoryCV.rx.items(cellIdentifier: BoroughCVCell.identifier, cellType: BoroughCVCell.self)) { row, element, cell in
                cell.configureUI(categoryTxt: element.toTitle)
            }
            .disposed(by: disposeBag)
        
        output.regionPost
            .bind(to: regionCV.rx.items(cellIdentifier: MeetupListCollectionViewCell.identifier, cellType: MeetupListCollectionViewCell.self)) { row, element, cell in
                cell.configureUI(data: element)
            }
            .disposed(by: disposeBag)
        
        regionCV.rx.modelSelected(ViewPostDetailResponse.self)
            .bind(onNext: { response in
                cellTapEvent.accept(response)
            })
            .disposed(by: disposeBag)
        
        output.cellTapEvent
            .bind(with: self) { owner, response in
                let vc = MeetupDetailViewController(viewModel: .init(detailPost: response))
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
extension SpecificRegionViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    func categoryCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(150),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}
