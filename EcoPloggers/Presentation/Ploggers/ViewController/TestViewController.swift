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
    var items: [ViewPostDetailResponseDTO]
}

extension MainDataSection: SectionModelType {
    typealias Item = ViewPostDetailResponseDTO
    
    init(original: MainDataSection, items: [ViewPostDetailResponseDTO]) {
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
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        return cv
    }()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MainDataSection>!
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bind()
    }
    
    func bind() {
        let input = TestViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.sectionData
            .bind(to: ploggingCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        ploggingCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                print(indexPath.section, indexPath.item)
            }
            .disposed(by: disposeBag)
    }
    func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MainDataSection>(configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            switch indexPath.section {
            case 0:
                guard let cell: BannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.configureUI(count: String(indexPath.item + 1), img: UIImage(systemName: "star.fill"))
                return cell
            case 1, 2:
                guard let cell: PloggingClubCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureUI(imageFile: UIImage(systemName: "star.fill"), creator: item.creator.nick, title: item.title, location: "문래")
                
                return cell
            default:
                guard let cell: PloggingClubCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PloggingClubCollectionViewCell.identifier, for: indexPath) as? PloggingClubCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureUI(imageFile: UIImage(systemName: "star.fill"), creator: item.creator.nick, title: item.title, location: "문래")
                
                return cell
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, headerText, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1,2:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                header.configureUI(headerText: "지금 뜨는 플로깅 모임")
                return header
            default:
                return UICollectionReusableView()
            }
        })
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
                return self.createFirstSectionLayout()
            case 1, 2:
                return self.createSecondSectionLayout()
            default:
                return self.createFirstSectionLayout()
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
        item.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.27)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
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
            heightDimension: .fractionalHeight(0.38)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
