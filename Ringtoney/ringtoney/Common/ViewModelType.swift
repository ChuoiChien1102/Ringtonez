//
//  ViewModelType.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import UIKit

protocol ViewModelType  {
    associatedtype Input
    associatedtype Output
    
    func transform( input: Input) -> Output
}


class ViewModel: NSObject {
    
    weak var coordinator: Coordinator?
    let bag = DisposeBag()
    
    var provider: AwesomeHudAPI?
    
    let loading = ActivityIndicator()
    let isLoading = PublishSubject<Bool>.init()
    
    
    override init() {
        super.init()
        self.provider = RestApi.init()
    }
    
    init(coordinator: Coordinator?, provider: AwesomeHudAPI?) {
        super.init()
        self.coordinator = coordinator
        //self.provider = provider
        self.provider = RestApi.init()
    }
    
    init(coordinator: Coordinator?) {
        super.init()
        self.coordinator = coordinator
        self.provider = RestApi.init()
    }

    deinit {
        log.debug("\(type(of: self)): Deinited")
    }
}
