//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 김태훈 on 2021/02/09.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
    //    var itemsCount: Int = 5
    //    var totalPrice: PublishSubject<Int> = PublishSubject()
    
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])

    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
//        let menus: [Menu] = [
//            Menu(id: 0, name: "튀김1", price: 100, count: 0),
//            Menu(id: 1, name: "튀김2", price: 100, count: 0),
//            Menu(id: 2, name: "튀김3", price: 100, count: 0),
//            Menu(id: 3, name: "튀김4", price: 100, count: 0)
//        ]
//        menuObservable.onNext(menus)

        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            .map { menuItems in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
        
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
            }
            // 한 번만 수행할거야!
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func onOrder() {
        
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count)
                    }
                }
            }
            // 한 번만 수행할거야!
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
