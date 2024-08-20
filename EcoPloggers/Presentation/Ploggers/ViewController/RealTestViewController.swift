//
//  RealTestViewController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/19/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class RealTestViewController: BaseViewController {
    private var vm = RealViewModel()
    private var disposeBag = DisposeBag()
    private let btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("이거 누르면 통신됨", for: .normal)
        btn.backgroundColor = .core
        return btn
    }()
    
    private let idLabel = PlainLabel(fontSize: Constant.Font.bold13)
    private let pwLabel = PlainLabel(fontSize: Constant.Font.bold13)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    func bind() {
        let input = RealViewModel.Input(btnTapEvent: btn.rx.tap)
        let output = vm.transform(input: input)
        
        output.idTxt
            .bind(with: self, onNext: { owner, text in
                owner.idLabel.text = text
            })
            .disposed(by: disposeBag)
        
        output.pwTxt
            .bind(with: self, onNext: { owner, text in
                owner.pwLabel.text = text
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [idLabel, pwLabel, btn]
            .forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        super.configureLayout()
        
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(50)
            make.horizontalEdges.equalTo(safeArea).inset(20)
        }
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(idLabel)
        }
        idLabel.backgroundColor = .blueGreen
        pwLabel.backgroundColor = .carrotOrange
    }
}
