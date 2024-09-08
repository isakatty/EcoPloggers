//
//  EditMeetupViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/8/24.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class EditMeetupViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    
    private let viewModel: EditViewModel
    
    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        
        super.init()
        bind()
    }
    
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
    private let categoryCV: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: categoryCVLayout())
        cv.register(BoroughCVCell.self, forCellWithReuseIdentifier: BoroughCVCell.identifier)
        cv.backgroundColor = Constant.Color.white
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
    private let chosedImg = BehaviorRelay<NSItemProviderReading?>(value: nil)
    private let rightSaveBtn = UIBarButtonItem(title: "수정", style: .done, target: self, action: nil)
    
    private func bind() {
        bindPHPicker()
        let input = EditViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        )
        let output = viewModel.transform(input: input)
        
        output.wrotedPost
            .bind(with: self) { owner, detailPost in
                owner.selectedImg.setImgWithHeaders(path: detailPost.files.first)
                owner.titleTFView.textField.text = detailPost.title
                owner.commentTFView.textView.text = detailPost.content
                owner.priceTFView.textField.text = detailPost.price
            }
            .disposed(by: disposeBag)
        
        output.category
            .bind(to: categoryCV.rx.items(
                cellIdentifier: BoroughCVCell.identifier,
                cellType: BoroughCVCell.self)
            ) { row, element, cell in
                cell.configureUI(categoryTxt: element.toTitle)
            }
            .disposed(by: disposeBag)
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
    override func configureHierarchy() {
        [scrollView]
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
        
        configureModalBackBtn()
        navigationItem.rightBarButtonItem = rightSaveBtn
    }
    
}

extension EditMeetupViewController: PHPickerViewControllerDelegate {
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
                    
                    self.chosedImg.accept(image)
                }
            } else {
                print("여기로 빠지나?")
            }
        }
    }
}
