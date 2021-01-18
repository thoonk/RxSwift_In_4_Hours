//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    // Subject 설명하기 위함
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")

    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    /*
     BehaviorSubject
     - 데이터를 외부에서 넣어줄 수 있거나, subscribe()할 수 있음
     - 아무 값이 없다면 default값, 있다면 최신의 값
     
     PublishSubject
     - subscribe() 호출 이후 발생하면 데이터 전달해줌
     
     ReplaySubject
     - subscribe() 호출 이후 발생하면 그 전까지 전달했던 모든 것을 전달해줌
     
     AsyncSubject
     - subject가 완료될 시점에 가장 마지막 값이 전달됨
     
     Driver
     - UI에 직접 영향을 끼치는 API임을 알려주기 위한 용도로 사용함
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bindInput()
//        bindOutout()
        bindUI()
    }
    
    // weak self 안 쓸 수 있는 방법
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI
    func invert(_ b: Bool) -> Bool { return !b }
//
//    private func bindInput() {
//        idField.rx.text.orEmpty
//            .bind(to: idInputText)
//            .disposed(by: disposeBag)
//        idInputText
//            .map(checkEmailValid)
//            .bind(to: idValid)
//            .disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .bind(to: pwInputText)
//            .disposed(by: disposeBag)
//        pwInputText
//            .map(checkPasswordValid)
//            .bind(to: pwValid)
//            .disposed(by: disposeBag)
//    }
//
//    private func bindOutout() {
//        idValid.subscribe(onNext: { b in self.idValidView.isHidden = b })
//            .disposed(by: disposeBag)
//        pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b })
//            .disposed(by: disposeBag)
//        Observable.combineLatest(idValid, pwValid, resultSelector: { $0 && $1 })
//            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
//            .disposed(by: disposeBag)
//    }
    
    private func bindUI() {
        
        // Input 2 : id, pw 입력
        idField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
//            .subscribe (onNext: { email in
//                self.viewModel.setEmailText(email)
//            })
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: viewModel.pwText)
//            .subscribe (onNext: { pw in
//                self.viewModel.setPasswordText(pw)
//            })
            .disposed(by: disposeBag)
        
        // Output 2: id, pw 체크 결과
        viewModel.isEmailValid
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isPasswordValid
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Output 1 : 버튼의 enable 상태
        Observable.combineLatest(viewModel.isEmailValid, viewModel.isPasswordValid) { $0 && $1 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        // input: id입력, pw입력
        // 자동 캐스팅 안되기 때문에 asObservable()으로 캐스팅
//        let idInputOb: Observable<String> = idField.rx.text.orEmpty.asObservable()
//        let idValidOb = idInputOb.map(checkEmailValid).bind(to: idValid).disposed(by: disposeBag)

//        idValidOb.subscribe(onNext: { b in
//            //외부에서 통제하는 observable 넣을 수 있음
//            self.idValid.onNext(b)
//        })
        // stream에 흘러가는 옵저버블을 저장하는 것
//        idValidOb.bind(to: idValid)
        
//        let pwInputOb: Observable<String> = pwField.rx.text.orEmpty.asObservable()
//        let pwValidOb = pwInputOb.map(checkPasswordValid).bind(to: pwValid).disposed(by: disposeBag)
        
       
        // output: 불릿, 로그인버튼활성화
//        idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b})
//            .disposed(by: disposeBag)
//        pwValidOb.subscribe(onNext: { b in self.pwValidView.isHidden = b})
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1 })
//            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
//            .disposed(by: disposeBag)
        
        
//        idField.rx.text.orEmpty //text가 있거나 없거나
//            //            .filter { $0 != nil }
//            //            .map { $0! }
//            .map(checkEmailValid)
//            .subscribe(onNext: { b in
//                self.idValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext: { b in
//                self.pwValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            // 최근에 전달한 값들,, 둘 중에 하나만 바뀌어도 실행됨
//            // zip - 값 둘 다 받아야 진행됨
//            // merge - select할 수 없이 순서대로 전달됨
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: { s1, s2 in s1 && s2 }) // 2개의 스트림을 받아서 결정된 것으로 진행함
//            .subscribe(onNext: { b in
//                self.loginButton.isEnabled = b
//            })
//            .disposed(by: disposeBag)
    }
}
