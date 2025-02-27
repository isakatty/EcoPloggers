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
import iamport_ios

final class MeetupDetailViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let viewModel: MeetupDetailViewModel
    
    private let followBtnTapEvent = PublishRelay<String>()
    private let commentsHeaderTapEvent = PublishRelay<Void>()
    private let editMenuTap = PublishRelay<Void>()
    private let deleteMenuTap = PublishRelay<Void>()
    private let engagementBtnTapEvent = PublishRelay<ViewPostDetailResponse>()
    private lazy var detailCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVLayout())
        cv.register(MeetupInfoCVCell.self, forCellWithReuseIdentifier: MeetupInfoCVCell.identifier)
        cv.register(MeetupDetailCVCell.self, forCellWithReuseIdentifier: MeetupDetailCVCell.identifier)
        cv.register(MeetupCommentsCVCell.self, forCellWithReuseIdentifier: MeetupCommentsCVCell.identifier)
        cv.register(MeetupProfileCVCell.self, forCellWithReuseIdentifier: MeetupProfileCVCell.identifier)
        cv.register(PloggingClubHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier)
        cv.backgroundColor = Constant.Color.lightGray.withAlphaComponent(0.3)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    private lazy var bookmarkBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: rightBarMenu)
        btn.tintColor = Constant.Color.black
        return btn
    }()
    private var rightBarMenu: UIMenu {
        return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "글 수정", image: nil, handler: { [weak self] _ in
                print("Handler?")
                self?.editMenuTap.accept(())
            }),
            UIAction(title: "삭제", image: nil, attributes: .destructive, handler: { [weak self] _ in
                self?.deleteMenuTap.accept(())
            })
        ]
    }
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailSectionModel>!
    
    init(viewModel: MeetupDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        configureDataSource()
        bind()
    }
    
    private func bind() {
        let paymentResponse = PublishRelay<IamportResponse>()
        
        let input = MeetupDetailViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            followTapEvent: followBtnTapEvent,
            commentHeaderTap: commentsHeaderTapEvent,
            engageBtnTap: engagementBtnTapEvent,
            paymentResponse: paymentResponse,
            deleteMenuTap: deleteMenuTap,
            editMenuTap: editMenuTap
        )
        let output = viewModel.transform(input: input)
        
        output.postData
            .bind(to: detailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.detailPost
            .bind(with: self) { owner, post in
                let vc = CommentsViewController(viewModel: .init(post: post))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.followState
            .bind(with: self) { owner, followState in
                print(followState.toastMsg)
                owner.showToast(message: followState.toastMsg)
            }
            .disposed(by: disposeBag)
        
        output.paymentOutput
            .bind { [weak self] payment in
                guard let self else { return }
                
                if let payment {
                    Iamport.shared.payment(
                        navController: self.navigationController ?? UINavigationController(),
                        userCode: "imp57573124",
                        payment: payment
                    ) { iamportResponse in
                        guard let iamportResponse else { return }
                        paymentResponse.accept(iamportResponse)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.paymentResultToast
            .bind(with: self) { owner, paymentResultText in
                owner.showToast(message: paymentResultText)
            }
            .disposed(by: disposeBag)
        
        output.deleteSuccessToast
            .bind(with: self) { owner, successMSG in
                owner.showToast(message: successMSG)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        output.deleteFailToast
            .bind(with: self) { owner, failMSG in
                owner.showToast(message: failMSG)
            }
            .disposed(by: disposeBag)
        output.editPost
            .bind(with: self) { owner, detailPost in
                let vc = EditMeetupViewController(viewModel: .init(detailPost: detailPost))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
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
            case .commentSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetupCommentsCVCell.identifier, for: indexPath) as? MeetupCommentsCVCell else { return UICollectionViewCell() }
                if let firstComment = data.comments.first {
                    cell.configureUI(filePath: firstComment.creator.profileImage, nick: firstComment.creator.nick, comment: firstComment.content)
                } else {
                    cell.configureEmptyComments(noComments: true)
                }
                return cell
            case .profileSectionItem(let data):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MeetupProfileCVCell.identifier,
                    for: indexPath
                ) as? MeetupProfileCVCell else { return UICollectionViewCell() }
                
                cell.configureProfile(profile: data)
                cell.profileView.followBtn.rx.tap
                    .map {
                        if data.creator.user_id != UserDefaultsManager.shared.myUserID {
                            return data.creator.user_id
                        } else {
                            return ""
                        }
                    }
                    .bind(with: self, onNext: { owner, user_id in
                        owner.followBtnTapEvent.accept(user_id)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.profileView.engageBtn.rx.tap
                    .map {
                        return data.post
                    }
                    .bind(with: self) { owner, postData in
                        owner.engagementBtnTapEvent.accept(postData)
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 2:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                header.backgroundColor = Constant.Color.white
                
                let section = dataSource.sectionModels[indexPath.section]
                header.configureMeetupUI(headerText: section.title)
                
                header.clearBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.commentsHeaderTapEvent.accept(())
                    }
                    .disposed(by: header.disposeBag)
                
                return header
            default:
                guard let header: PloggingClubHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PloggingClubHeaderView.identifier, for: indexPath) as? PloggingClubHeaderView else { return UICollectionReusableView() }
                
                header.backgroundColor = Constant.Color.white
                
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
        view.backgroundColor = Constant.Color.white
        
        navigationItem.rightBarButtonItem = bookmarkBtn
        
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
            heightDimension: .fractionalHeight(0.61)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
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
        section.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        return section
    }
    /// Map layout
    private func createMapSectionLayout() -> NSCollectionLayoutSection {
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
        section.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        return section
    }
    private func createProfileSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createSectionHeader()]
        section.contentInsets = .init(top: 5, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(35)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
