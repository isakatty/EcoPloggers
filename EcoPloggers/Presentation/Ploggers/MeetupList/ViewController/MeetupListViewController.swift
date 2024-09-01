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
    
    private let listCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: listCVLayout())
        cv.register(
            MeetupListSndCVCell.self,
            forCellWithReuseIdentifier: MeetupListSndCVCell.identifier
        )
        cv.backgroundColor = Constant.Color.white
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
    
    private func bind() {
        let paginationTrigger = PublishRelay<Bool>()
        let selectedData = PublishRelay<ViewPostDetailResponse>()
        let input = MeetupViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            cellTapEvent: selectedData,
            paginationTrigger: paginationTrigger
        )
        let output = viewModel.transform(input: input)
        
        output.meetupList
            .asDriver()
            .drive(listCollectionView.rx.items(
                cellIdentifier: MeetupListSndCVCell.identifier,
                cellType: MeetupListSndCVCell.self)
            ) { row, element, cell in
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
                vc.navigationItem.title = detailData.title
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                owner.present(navi, animated: true)
            }
            .disposed(by: disposeBag)
        
        listCollectionView.rx.prefetchItems
            .bind(with: self) { owner, indexPathArray in
                if let indexPath = indexPathArray.first {
                    if output.meetupList.value.count - 6 == indexPath.item {
                        paginationTrigger.accept(true)
                    }
                } else {
                    print("네 ?")
                }
            }
            .disposed(by: disposeBag)
        
    }
    override func configureHierarchy() {
        view.addSubview(listCollectionView)
    }
    override func configureLayout() {
        view.backgroundColor = Constant.Color.white
        
        listCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension UIViewController {
    static func listCVLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
