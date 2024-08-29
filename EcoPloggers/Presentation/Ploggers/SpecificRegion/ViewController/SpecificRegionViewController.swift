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
    
    private var seoulLabel: PlainLabel = {
        let label = PlainLabel(fontSize: Constant.Font.medium17, txtColor: Constant.Color.black)
        label.text = "서울"
        label.textAlignment = .center
        label.backgroundColor = Constant.Color.white
        return label
    }()
    private lazy var regionCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.backgroundColor = Constant.Color.white
        cv.register(MeetupListCollectionViewCell.self, forCellWithReuseIdentifier: MeetupListCollectionViewCell.identifier)
        return cv
    }()
    private let seperateBar: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.lightGray
        return view
    }()
    
    private let selectedBorough = BehaviorRelay<Int>(value: 0)
    
    init(viewModel: SpecificRegionViewModel) {
        self.viewModel = viewModel
        super.init()
        
        bind()
    }
    
    override func configureHierarchy() {
        [categoryCV, regionCV, seoulLabel, seperateBar]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        view.backgroundColor = Constant.Color.white
        
        configureNavigationLeftBar(action: nil)
        
        seoulLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea)
            make.height.equalTo(45)
            make.width.equalTo(60)
        }
        seperateBar.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(45)
            make.leading.equalTo(seoulLabel.snp.trailing)
            make.top.equalTo(safeArea)
        }
        categoryCV.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(4)
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
            selectedBorough: selectedBorough,
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            cellTapEvent: cellTapEvent
        )
        let output = viewModel.transform(input: input)
        
        output.categoryRegion
            .bind(to: categoryCV.rx.items(cellIdentifier: BoroughCVCell.identifier, cellType: BoroughCVCell.self)) { row, element, cell in
                cell.configureUI(categoryTxt: element.toTitle)
                
                if output.selectedBorough.value == row {
                    cell.selectedUI()
                } else {
                    cell.unSelectedUI()
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedBorough
            .bind(with: self) { owner, _ in
                owner.categoryCV.reloadData()
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
        
        categoryCV.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.selectedBorough.accept(indexPath.item)
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
        section.contentInsets = .init(top: 0, leading: 65, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}
