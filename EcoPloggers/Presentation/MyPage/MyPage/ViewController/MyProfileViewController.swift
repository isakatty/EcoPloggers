//
//  MyProfileViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/2/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MyProfileViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let viewModel = MyProfileViewModel()
    
    private let profileView = MyProfileTopView()
    private let segmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        for (index, item) in EcoProfile.allCases.enumerated() {
            seg.insertSegment(with: item.toImg, at: index, animated: true)
        }
        seg.selectedSegmentIndex = 0
        return seg
    }()
    private lazy var dataCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createFavoriteLayout())
        cv.register(EcoProfileCVCell.self, forCellWithReuseIdentifier: EcoProfileCVCell.identifier)
        cv.backgroundColor = Constant.Color.mainBG
        return cv
    }()
    private let selectedSeg = BehaviorRelay<Int>(value: 0)
    private lazy var rightSettingBtn = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: nil)
    private let withdrawBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = Constant.Color.secondaryBG?.withAlphaComponent(0.4)
        var titleAttribute = AttributedString("탈퇴하기")
        titleAttribute.font = Constant.Font.regular12
        titleAttribute.foregroundColor = Constant.Color.lightGray.withAlphaComponent(0.7)
        config.attributedTitle = titleAttribute
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    override init() {
        super.init()
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.titleTextAttributes = [.font: Constant.Font.medium20]
        
        navigationItem.rightBarButtonItem = rightSettingBtn
    }
    
    override func configureHierarchy() {
        [profileView, segmentControl, dataCollectionView, withdrawBtn]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(150)
        }
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(40)
        }
        dataCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.horizontalEdges.equalTo(safeArea)
            make.bottom.equalTo(withdrawBtn.snp.top).inset(20)
        }
        withdrawBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.snp.bottom)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
    }
    
    func bind() {
        let logout = PublishRelay<Void>()
        let input = MyProfileViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            segmented: segmentControl.rx.selectedSegmentIndex,
            logout: logout
        )
        let output = viewModel.transform(input: input)
        
        output.myProfile
            .bind(with: self) { owner, response in
                owner.profileView.configureUI(profile: response)
            }
            .disposed(by: disposeBag)
        
        output.posts
            .bind(to: dataCollectionView.rx.items(cellIdentifier: EcoProfileCVCell.identifier, cellType: EcoProfileCVCell.self)) { row, element, cell in
                cell.configureUI(filePath: element.files.first)
            }
            .disposed(by: disposeBag)
        
        rightSettingBtn.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "로그아웃", message: "정말 로그아웃하시겠습니까?", ok: "네") {
                    logout.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.logoutResult
            .bind(with: self) { owner, logout in
                if logout {
                    owner.setRootViewController(UINavigationController(rootViewController: LogInViewController()))
                }
            }
            .disposed(by: disposeBag)
    }
}
extension MyProfileViewController {
    private func createFavoriteLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    private enum EcoProfile: Int, CaseIterable {
        case myPosts
        case favorite
        
        var toImg: UIImage? {
            switch self {
            case .favorite:
                return UIImage(systemName: "heart")
            case .myPosts:
                return UIImage(systemName: "pencil.and.list.clipboard")
            }
        }
    }
}
