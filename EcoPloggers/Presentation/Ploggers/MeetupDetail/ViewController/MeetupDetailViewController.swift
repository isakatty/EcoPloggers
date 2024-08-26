//
//  MeetupDetailViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/24/24.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit

final class MeetupDetailViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let viewModel: MeetupDetailViewModel
    
    private lazy var detailCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(MeetupInfoCVCell.self, forCellWithReuseIdentifier: MeetupInfoCVCell.identifier)
        cv.register(MeetupDetailCVCell.self, forCellWithReuseIdentifier: MeetupDetailCVCell.identifier)
        cv.register(MeetupMapCVCell.self, forCellWithReuseIdentifier: MeetupMapCVCell.identifier)
        cv.register(MeetupProfileCVCell.self, forCellWithReuseIdentifier: MeetupProfileCVCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        return cv
    }()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailSectionModel>!
    
    init(viewModel: MeetupDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        configureDataSource()
        bind()
    }
    
    private func bind() {
        let input = MeetupDetailViewModel.Input(viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in })
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(to: detailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .detailSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetupDetailCVCell.identifier, for: indexPath) as? MeetupDetailCVCell else { return UICollectionViewCell() }
                cell.configureUI(content: data.content)
                return cell
            case .infoSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetupInfoCVCell.identifier, for: indexPath) as? MeetupInfoCVCell
                else { return UICollectionViewCell() }
                cell.configureCompoUI(time: data.required_time, people: data.recruits, date: data.due_date)
                cell.configureUI(bgImgFilePath: data.files.first, category: RegionBorough(rawValue: data.product_id ?? "eco_111231")?.toTitle, titleTxt: data.title, price: data.price)
                return cell
            case .mapSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetupMapCVCell.identifier, for: indexPath) as? MeetupMapCVCell else { return UICollectionViewCell() }
//                cell.configure
                return cell
            case .profileSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetupProfileCVCell.identifier, for: indexPath) as? MeetupProfileCVCell else { return UICollectionViewCell() }
                cell.configureProfile(profile: data)
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            default:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                let section = dataSource.sectionModels[indexPath.section]
                header.configureMeetupUI(headerText: section.title)
                
                return header
            }
        })
    }
    
    override func configureHierarchy() {
        configureModalBackBtn()
        
        [detailCollectionView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
//        super.configureLayout()
        view.backgroundColor = Constant.Color.white
        
        detailCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
}
extension MeetupDetailViewController {
    private func configureCVLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createInfoSectionLayout()
            case 1:
                return self.createDetailSectionLayout()
            case 2:
                return self.createMapSectionLayout()
            case 3:
                return self.createProfileSectionLayout()
            default:
                return self.createMapSectionLayout()
            }
        }
        return layout
    }
    /// Info layout
    private func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.81)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    /// Content Detail layout
    private func createDetailSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    /// Map layout
    private func createMapSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    private func createProfileSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
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
