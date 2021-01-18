//
//  ViewModel.swift
//  RxSwiftIn4Hours
//
//  Created by 김태훈 on 2021/01/18.
//  Copyright © 2021 n.code. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    
    // Input
    let emailText = BehaviorSubject(value: "")
    let pwText = BehaviorSubject(value: "")
    
    // Output
    let isEmailValid = BehaviorSubject(value: false)
    let isPasswordValid = BehaviorSubject(value: false)
    
    init() {
        _ = emailText.distinctUntilChanged()
            .map(checkEmailValid)
            .bind(to: isEmailValid)
        
        _ = pwText.distinctUntilChanged()
            .map(checkPasswordValid(_:))
            .bind(to: isPasswordValid)
    }
    
//    func setEmailText(_ email: String) {
//        let isValid = checkEmailValid(email)
//        isEmailValid.onNext(isValid)
//    }
//
//    func setPasswordText(_ pw: String) {
//        let isValid = checkPasswordValid(pw)
//        isPasswordValid.onNext(isValid)
//    }
    
    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
