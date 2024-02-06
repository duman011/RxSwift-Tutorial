//
//  BaseViewModel.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import RxSwift
import RxCocoa

class BaseViewModel {
    let isLoad = BehaviorRelay<Bool>.init(value: false)
    let disposeBag = DisposeBag()
}
