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
    
    private let regionView = BoroughView()
    private let clearBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Constant.Color.clear
        return btn
    }()
    private lazy var regionCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.backgroundColor = Constant.Color.mainBG
        cv.register(MeetupListCVCell.self, forCellWithReuseIdentifier: MeetupListCVCell.identifier)
        return cv
    }()
    
    init(viewModel: SpecificRegionViewModel) {
        self.viewModel = viewModel
        super.init()
        
        bind()
    }
    
    override func configureHierarchy() {
        [regionView, clearBtn, regionCV]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        regionView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(8)
            make.leading.equalTo(safeArea).inset(12)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        clearBtn.snp.makeConstraints { make in
            make.edges.equalTo(regionView)
        }
        regionCV.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.top.equalTo(clearBtn.snp.bottom)
        }
    }
    private func bind() {
        let cellTapEvent = PublishRelay<ViewPostDetailResponse>()
        let input = SpecificRegionViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            cellTapEvent: cellTapEvent
        )
        let output = viewModel.transform(input: input)
        
        output.regionName
            .bind(with: self) { owner, regionName in
                owner.regionView.configureUI(regionName: regionName)
            }
            .disposed(by: disposeBag)
        
        output.regionPost
            .bind(to: regionCV.rx.items(cellIdentifier: MeetupListCVCell.identifier, cellType: MeetupListCVCell.self)) { row, element, cell in
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
        
//        clearBtn.rx.tap
//            .map {
//                
//            }
    }
}
extension SpecificRegionViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
