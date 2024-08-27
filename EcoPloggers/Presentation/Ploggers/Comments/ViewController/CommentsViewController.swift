//
//  CommentsViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/26/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class CommentsViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let commentTFView = CommentsView()
    private let viewModel: CommentsViewModel
    private lazy var commentsCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(MeetupCommentsCVCell.self, forCellWithReuseIdentifier: MeetupCommentsCVCell.identifier)
        return cv
    }()
    
    init(viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureHierarchy() {
        [commentsCV, commentTFView]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        commentsCV.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
        }
        commentTFView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(commentsCV.snp.bottom)
            make.height.equalTo(60)
        }
    }
    private func bind() {
        let input = CommentsViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.comments
            .bind(to: commentsCV.rx.items(cellIdentifier: MeetupCommentsCVCell.identifier, cellType: MeetupCommentsCVCell.self)) { row, element, cell in
                print(element, "🔔")
                cell.configureUI(filePath: element.creator.profileImage, nick: element.creator.nick, comment: element.content)
            }
            .disposed(by: disposeBag)
    }
    
}
extension CommentsViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
