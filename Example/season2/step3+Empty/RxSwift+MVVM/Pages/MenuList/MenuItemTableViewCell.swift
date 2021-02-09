//
//  MenuItemTableViewCell.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var price: UILabel!
    
    var onChange: ((Int) -> Void)?

    @IBAction func onIncreaseCount() {
        onChange?(+1)
    }

    @IBAction func onDecreaseCount() {
        onChange?(-1)
    }
    
    override func prepareForReuse() {
        // 이런 식으로 다른 뷰 모델을 연결할 경우 다시 사용되는 셀에 대한 바인딩 끊어주기
//        dispose = DisposeBag()
    }
}
