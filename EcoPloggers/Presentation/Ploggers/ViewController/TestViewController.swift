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
    var items: [ViewPostResponse]
}

extension MainDataSection: SectionModelType {
    typealias Item = ViewPostResponse
    
    init(original: MainDataSection, items: [ViewPostResponse]) {
        self = original
        self.items = items
    }
}

final class TestViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let viewModel = TestViewModel()
    private lazy var ploggingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        cv.register(PloggingClubCollectionViewCell.self, forCellWithReuseIdentifier: PloggingClubCollectionViewCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
    }
    
    override func configureHierarchy() {
        view.addSubview(ploggingCollectionView)
    }
    override func configureLayout() {
        super.configureLayout()
        
        ploggingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
}

extension TestViewController {
    private func configureCVLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { return nil }
            switch sectionIndex {
            case 0:
                // 첫 번째 섹션 레이아웃
                return self.createFirstSectionLayout()
            case 1:
                // 두 번째 섹션 레이아웃
                return self.createSecondSectionLayout()
            case 2:
                // 세 번째 섹션 레이아웃
                return self.createThirdSectionLayout()
            default:
                return self.createDefaultSectionLayout()
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
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createSecondSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createThirdSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(30)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
