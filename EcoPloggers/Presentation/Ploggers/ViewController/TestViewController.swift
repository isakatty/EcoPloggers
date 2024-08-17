//
//  TestViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class TestViewController: BaseViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = PloggersViewModel()
    private lazy var cv: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        cv.backgroundColor = .core
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        let input = PloggersViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.regions
            .bind(to: cv.rx.items(cellIdentifier: RegionCollectionViewCell.identifier, cellType: RegionCollectionViewCell.self)) { row, element, cell in
                cell.configureLabel(regionName: element.rawValue)
            }
            .disposed(by: disposeBag)
        
        cv.rx.itemSelected
            .bind { index in
                print(index)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(cv)
    }
    override func configureLayout() {
        super.configureLayout()
        
        cv.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(300)
        }
    }
}

extension TestViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
