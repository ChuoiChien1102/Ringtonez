//
//  CategoryViewModel.swift
//  ringtoney
//
//  Created by dong ka on 11/2/20.
//  Copyright (c) 2020 All rights reserved.
//

import Foundation


class CategoryViewModel: ViewModel , ViewModelType {
    
    //MARK:- Property
    var page: Int = 0
    
    //MARK:- Init
    override init() {
        super.init()
        self.provider = RestApi.init()
    }
    
    //MARK:- Input
    struct Input {
        let trigger: Observable<Void>
        let selection: Driver<CatalogSectionItem>
        let trendingSelected: Observable<Category?>
        let searchRingtone: Observable<String?>
    }
    
    //MARK:- Output
    struct Output {
        let items: Driver<[CatalogSectionModel]>
    }
    
    //MARK:- Transform
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[CatalogSectionModel]>.init(value: [])
        
        let refresh = Observable.of(input.trigger).merge()
        
//        request()
//            .bind(to: elements)
//            .disposed(by: bag)
                
        Observable.concat([self.getListTopCategories(), self.getListCategories()])
            .subscribe(onNext: { arr in
                elements.accept(elements.value + arr)
            })
            .disposed(by: bag)
        
        input.selection.asObservable()
            .subscribe(onNext:{ cate in
                switch cate {
                case .category(let model):
                    guard let coordinator = self.coordinator as? CategoryCoordinator else { return }
                    coordinator.openCategoryDetail(model.category)
                case .trend(_) : break
                }
            })
            .disposed(by: bag)
        
        input.trendingSelected
            .compactMap { $0 }
            .subscribe(onNext:{[weak self] model in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? CategoryCoordinator else { return }
                coordinator.openCategoryDetail(model)
            })
            .disposed(by: bag)
        
        input.searchRingtone
            .compactMap{$0}
            .subscribe(onNext:{[weak self] searchString in
                guard let self = self else { return }
                guard let coordinator = self.coordinator as? CategoryCoordinator else { return }
                coordinator.openSearchDetail(searchString)
            })
            .disposed(by: bag)
        
        
        return Output.init(items: elements.asDriver(onErrorJustReturn: []))
    }
    
    //MARK:- Logic&Functions
    
    func getListTopCategories() -> Observable<[CatalogSectionModel]> {
        return Observable.create { (observable) -> Disposable in
            self.provider?.topCategories(page: self.page)
                .subscribe(onSuccess: { (cateArray) in
                    
                    let treding = Trending.init()
                    treding.categories.removeAll()
                    for i in cateArray {
                        treding.categories.append(i)
                    }
                    
                    let topCategoriesSection =
                        CatalogSectionModel.topCategoriesSection(
                            title: "Top categories",
                            items: [
                                CatalogSectionItem.trend(.init(trending: treding))
                            ])
                    
                    observable.onNext([topCategoriesSection])
                    observable.onCompleted()
                    
                }, onError: { (error) in
                    //Catch error
                    log.debug(error)
                    observable.onNext([])
                    observable.onCompleted()
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }
    }

    
    func getListCategories() -> Observable<[CatalogSectionModel]> {
        return Observable.create { (observable) -> Disposable in
            self.provider?.listCategories(page: self.page)
                .subscribe(onSuccess: { (cateArray) in
                    var genresItems: [CatalogSectionItem] = []
                    //code
                    for i in cateArray {
                        let genItem = CatalogSectionItem.category(.init(category: i))
                        genresItems.append(genItem)
                    }
                    let genresSection =
                        CatalogSectionModel.genresSection(
                            title: "Genres",
                            items: genresItems)
                    observable.onNext([genresSection])
                    observable.onCompleted()
                }, onError: { (error) in
                    //Catch error
                    log.debug(error)
                    observable.onNext([])
                    observable.onCompleted()
                })
                .disposed(by: self.bag)
            return Disposables.create()
        }
    }

    
    func request() -> Observable<[CatalogSectionModel]> {
        return Observable.create { (o) -> Disposable in
            log.debug("Calllll")
            var items: [CatalogSectionModel] = []
            
            let topCategoriesSection =
                CatalogSectionModel.topCategoriesSection(
                    title: "Top categories",
                    items: [
                        CatalogSectionItem.trend(.init(trending: .init()))
                    ])
            
            items += [topCategoriesSection]
                        
            self.provider?.listCategories(page: self.page)
                .subscribe(onSuccess: { (cateArray) in
                    
                    var genresItems: [CatalogSectionItem] = []
                    
                    //code
                    for i in cateArray {
                        let genItem = CatalogSectionItem.category(.init(category: i))
                        genresItems.append(genItem)
                    }
                    
                    let genresSection =
                        CatalogSectionModel.genresSection(
                            title: "Genres",
                            items: genresItems)
                    
                    
                    items += [ genresSection]
                    
                    o.onNext(items)
                    o.onCompleted()
                    
                }, onError: { (error) in
                    //Catch error
                    log.debug(error)
                    
                    o.onNext(items)
                    o.onCompleted()
                })
                .disposed(by: self.bag)
            
            return Disposables.create()
        }
    }
    
    
}

