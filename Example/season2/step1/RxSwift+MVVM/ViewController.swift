//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    // dispose하는 방식
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        disposable?.dispose()
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    func downloadJSON(_ url: String, _ completion: @escaping (String?) -> Void) {
        // 비동기 처리
        DispatchQueue.global().async {
            let url = URL(string: url)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
    
    // Observable 생명주기
    // 1. Create
    // 2. Subscribe
    // 3. onNext
    // 4. onCompleted or onError
    // 5. Disposed
    
    func downloadJSON(_ url: String) -> Observable<String> {
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        // sugar api
        // Just
//        return Observable.just(["Hello", "World"])
        
        // From
//        return Observable.from(["Hello", "World"])

        
        return Observable.create() { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }

                if let data = data, let json = String(data: data, encoding: .utf8) {
                    emitter.onNext(json)
                }

                emitter.onCompleted()
            }

            task.resume()

            return Disposables.create() {
                task.cancel()
            }
        }
        
        
//        return Observable.create() { emitter in
//            emitter.onNext("Hello")
//            emitter.onNext("World")
//            emitter.onCompleted()
//
//            return Disposables.create()
//        }
        
        
//        return Observable.create { f in
//            let url = URL(string: url)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)
//            DispatchQueue.main.async {
//                f.onNext(json)
//                // 순환 참조 문제 해결
//                f.onCompleted()
//            }
//            return Disposables.create()
//        }
    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
//        let observable = downloadJSON(MEMBER_LIST_URL)
        let jsonObservable = downloadJSON(MEMBER_LIST_URL)
        let helloObservable = Observable.just("Hello World")
        
        Observable.zip(jsonObservable, helloObservable) { $0 + "\n" + $1 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { json in
                
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            .disposed(by: disposeBag)
        
//        disposeBag.insert(disposable)
        
//        observable
//            .map { json in json?.count ?? 0 }
//            .filter { cnt in cnt > 0 }
//            .map { "\($0)" }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { json in
//                self.editView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            })

        
//        observable.subscribe(onNext: { print($0) },
//                             onError: { err in print(err) },
//                             onCompleted: { print("Completed") })
//
    

        
//        let disposable = observable.subscribe { event in
//            switch event {
//            case .next(let t):
//                print(t)
//                break
//            case .completed:
//                break
//            case .error:
//                break
//            }
//        }
        
        
//        let disposable = downloadJSON(MEMBER_LIST_URL)
//            .debug()
//            .subscribe { event in
//            switch event {
//            case .next(let json):
//                DispatchQueue.main.async {
//                    self.editView.text = json
//                    self.setVisibleWithAnimation(self.activityIndicator, false)
//                }
//            case .completed:
//                break
//            case .error:
//                break
//            }
//        }
//        disposable.dispose()
    }
}
