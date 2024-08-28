//
//  PostMeetupViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/27/24.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa
import SnapKit

/*
 left bar btn item -> dismiss
 하단에 upload btn
 
 1. 이미지 - 필수
 ~~2. title
 ~~3. comment
 4. category
 5. 가격
 6. 인원 - optional - 제한 없음 -> PickerView 굳이.
 7. 마감 날짜 - optional - 상시 모집 -> DatePicker
 8. 소요시간 - optional - 없으면 시간 협의
 */

final class PostMeetupViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    
    private let viewModel = PostViewModel()
    private let scrollView = UIScrollView()
    private let scrollContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let addImgBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate).withTintColor(Constant.Color.white)
        config.baseBackgroundColor = Constant.Color.lightGray.withAlphaComponent(0.4)
        let btn = UIButton(configuration: config)
        return btn
    }()
    private let selectedImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    private let categoryTitle: PlainLabel = {
        let lb = PlainLabel(fontSize: Constant.Font.regular12, txtColor: Constant.Color.black)
        lb.text = "지역"
        return lb
    }()
    private lazy var categoryCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(BoroughCVCell.self, forCellWithReuseIdentifier: BoroughCVCell.identifier)
        cv.backgroundColor = Constant.Color.white
//        cv.alwaysBounceVertical = false
        return cv
    }()
    private let titleTFView: TitleTextFieldView = {
        let view = TitleTextFieldView(title: "제목", placeholder: "제목을 입력하세요.")
        return view
    }()
    private let priceTFView: TitleTextFieldView = {
        let view = TitleTextFieldView(title: "가격", placeholder: "가격을 입력하세요.")
        view.textField.keyboardType = .numberPad
        return view
    }()
    private let commentTFView: TitleContentView = {
        let view = TitleContentView(title: "자세한 설명", placeholder: "아직 어차피 안나와요")
        return view
    }()
    private let uploadBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Constant.Color.blueGreen
        config.titleAlignment = .center
        var titleAttribute = AttributedString("작성 완료")
        titleAttribute.font = Constant.Font.medium16
        titleAttribute.foregroundColor = Constant.Color.white
        config.attributedTitle = titleAttribute
        let btn = UIButton(configuration: config)
        return btn
    }()
    private let chosedImg = BehaviorRelay<NSItemProviderReading?>(value: nil)

    override init() {
        super.init()
        
        bind()
    }
    private func bindPHPicker() {
        addImgBtn.rx.tap
            .bind(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.filter = .any(of: [.images])
                configuration.selectionLimit = 1
                
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = owner
                owner.present(picker, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        bindPHPicker()
        let selectedCategory = BehaviorRelay<Int>(value: 0)
        let input = PostViewModel.Input(
            selectedImg: chosedImg,
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in },
            postBtnTapEvent: uploadBtn.rx.tap,
            titleText: titleTFView.textField.rx.text.orEmpty,
            contentText: commentTFView.textView.rx.text.orEmpty,
            priceText: priceTFView.textField.rx.text.orEmpty,
            selectedCategory: selectedCategory
        )
        let output = viewModel.transform(input: input)
        
        output.category
            .bind(to: categoryCV.rx.items(cellIdentifier: BoroughCVCell.identifier, cellType: BoroughCVCell.self)) { row, element, cell in
                cell.configureUI(categoryTxt: element.toTitle)
                
                if row == output.selectedCategory.value {
                    cell.selectedUI()
                } else {
                    cell.unSelectedUI()
                }
                
            }
            .disposed(by: disposeBag)
        
        output.avaliablPostBtn
            .bind(with: self) { owner, boolean in
                owner.uploadBtn.isEnabled = boolean
            }
            .disposed(by: disposeBag)
        
        output.selectedCategory
            .bind(with: self) { owner, _ in
                owner.categoryCV.reloadData()
            }
            .disposed(by: disposeBag)
        
        categoryCV.rx.itemSelected
            .bind(onNext: { indexPath in
                print(indexPath.item)
                selectedCategory.accept(indexPath.item)
            })
            .disposed(by: disposeBag)
        
        output.successUpload
            .bind(with: self) { owner, isUploaded in
                if isUploaded {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    override func configureHierarchy() {
        [scrollView, uploadBtn]
            .forEach { view.addSubview($0) }
        scrollView.addSubview(scrollContainerView)
        
        [addImgBtn, selectedImg, titleTFView, priceTFView, commentTFView, categoryTitle, categoryCV]
            .forEach { scrollContainerView.addSubview($0) }
    }
    override func configureLayout() {
        scrollView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = Constant.Color.white
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        uploadBtn.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        scrollContainerView.snp.makeConstraints { make in
            make.width.verticalEdges.equalTo(scrollView)
        }
        addImgBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(100)
        }
        selectedImg.snp.makeConstraints { make in
            make.verticalEdges.equalTo(addImgBtn)
            make.width.height.equalTo(addImgBtn)
            make.leading.equalTo(addImgBtn.snp.trailing).inset(-12)
        }
        titleTFView.snp.makeConstraints { make in
            make.top.equalTo(addImgBtn.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        commentTFView.snp.makeConstraints { make in
            make.top.equalTo(titleTFView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(250)
        }
        categoryTitle.snp.makeConstraints { make in
            make.top.equalTo(commentTFView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        categoryCV.snp.makeConstraints { make in
            make.top.equalTo(categoryTitle.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        priceTFView.snp.makeConstraints { make in
            make.top.equalTo(categoryCV.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalTo(scrollContainerView).inset(60)
        }
        selectedImg.isHidden = true
        
        configureModalBackBtn()
    }
    
}

extension PostMeetupViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        dismiss(animated: true)
        let itemProvider = results.last?.itemProvider
        
        guard let itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else {
            print("로드할 수 없는 상태이거나, results가 없거나")
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self else { return }
            if let image {
                print(image)
                DispatchQueue.main.async {
                    self.selectedImg.image = image as? UIImage
                    self.selectedImg.isHidden = false
                    
                    // VC -> VM 이미지 전달
                    self.chosedImg.accept(image)
                }
            } else {
                print("여기로 빠지나?")
            }
        }
    }
}
extension PostMeetupViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}

