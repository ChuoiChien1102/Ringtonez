////
////  Api.swift
////  ringtoney
////
////  Created by dong ka on 10/29/20.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//
protocol AwesomeHudAPI {
//    
    func downloadFile(url: URL, fileName: String?) -> Single<Any>
//
//    
//
    
    //Get list category
    func listCategories( page: Int) -> Single<[Category]>
    func topCategories(page: Int) -> Single<[Category]>

    //Detail categories
    func detailCategory( cateId: Int, page: Int) -> Single<[Ringtone]>
    
    //Search
    func search( key: String, page: Int) -> Single<[Ringtone]>
    
}
