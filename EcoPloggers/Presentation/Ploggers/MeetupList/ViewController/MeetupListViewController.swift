//
//  MeetupListViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/23/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MeetupListViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private var viewModel: MeetupViewModel
    
    private lazy var listCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(MeetupListCVCell.self, forCellWithReuseIdentifier: MeetupListCVCell.identifier)
        cv.backgroundColor = Constant.Color.mainBG
        return cv
    }()
    
    init(viewModel: MeetupViewModel) {
        self.viewModel = viewModel
        super.init()
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationLeftBar(action: nil)
    }
    
    func bind() {
        let selectedData = PublishRelay<ViewPostDetailResponse>()
        let input = MeetupViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            cellTapEvent: selectedData)
        let output = viewModel.transform(input: input)
        
        output.meetupList
            .asDriver()
            .drive(listCollectionView.rx.items(cellIdentifier: MeetupListCVCell.identifier, cellType: MeetupListCVCell.self)) { row, element, cell in
                cell.configureUI(data: element)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(listCollectionView.rx.itemSelected, listCollectionView.rx.modelSelected(ViewPostDetailResponse.self))
            .bind(with: self) { owner, arg1 in
                selectedData.accept(arg1.1)
            }
            .disposed(by: disposeBag)
        output.cellTapEvent
            .bind(with: self) { owner, detailData in
                let vc = MeetupDetailViewController(viewModel: MeetupDetailViewModel(detailPost: detailData))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

    }
    override func configureHierarchy() {
        view.addSubview(listCollectionView)
    }
    override func configureLayout() {
        super.configureLayout()
        
        listCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension MeetupListViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.28)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
