//
//  LastTestViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class LastTestViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    lazy var cv: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cv)
        cv.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        bind()
    }
    func bind() {
        
        let data = Observable.just(["1","2","3","4","5"])
        
        data
            .bind(to: cv.rx.items(cellIdentifier: BannerCollectionViewCell.identifier, cellType: BannerCollectionViewCell.self)) { row, element, cell in
                cell.configureUI(count: element, img: UIImage(systemName: "star.fill"))
            }
            .disposed(by: disposeBag)
        
        cv.rx.itemSelected
            .bind { indexPath in
                print(indexPath)
            }
            .disposed(by: disposeBag)
    }
    
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
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
