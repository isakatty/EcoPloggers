//
//  LogInViewModel.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/15/24.
//

import Foundation

import RxSwift
import RxCocoa

final class LogInViewModel: ViewModelType {
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let emailString: ControlProperty<String>
        let pwString: ControlProperty<String>
        let logInEvent: ControlEvent<Void>
        let signUpEvent: ControlEvent<Void>
    }
    struct Output {
        let validation: BehaviorRelay<Bool>
        let logInEvent: ControlEvent<Void>
        let signUpEvent: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        
        
        
        return Output(
            validation: .init(value: true),
            logInEvent: input.logInEvent,
            signUpEvent: input.signUpEvent
        )
    }
}
