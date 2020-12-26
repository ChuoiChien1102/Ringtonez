//
//  RestApi.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper
import Moya

class RestApi : NSObject {
    
    var callBackQueue: DispatchQueue?
    
    let moya = AwesomeProvider
    
    func cancelRequest() {
        AF.session.invalidateAndCancel()
    }
    
    override init() {
        super.init()
    }
    
    init( queue: DispatchQueue) {
        super.init()
    }
    
}

extension RestApi : AwesomeHudAPI {
    
    func topCategories(page: Int) -> Single<[Category]> {
        requestArray(.topCategories(page: page), type: Category.self)
    }
    
    func listCategories(page: Int) -> Single<[Category]> {
        requestArray(.listCategories(page: page), type: Category.self)
    }
    
    func downloadFile(url: URL, fileName: String?) -> Single<Any> {
        requestDownload(.download(url: url, fileName: fileName))
    }
    
    func detailCategory( cateId: Int, page: Int) -> Single<[Ringtone]> {
        requestArray(.detailCategory(cateId: cateId, page: page), type: Ringtone.self)
    }
    
    func search(key: String, page: Int) -> Single<[Ringtone]> {
        requestArray(.search(key: key, page: page), type: Ringtone.self)
    }

}

extension RestApi {

    private func request(_ target: DNAPITarget) -> Single<Any> {
        return Single.create { single in
            DispatchQueue.global().async {
                self.moya.request(target) { (response) in
                    do {
                        single(.success(response))
                    } catch ( let _error ) {
                        single(.error(_error))
                    }
                }
            }
            return Disposables.create { }
        }
        .observeOn(MainScheduler.instance)
    }

    private func requestAnyObject(_ target: DNAPITarget) -> Single<Any> {
        return Single.create { single in
            DispatchQueue.global().async {
                self.moya.request(target) { (result) in
                    do {
                        let response = try result.get()
                        let json = try JSON.init(data: response.data)
                        //log.debug(json)
                        if let code = json["code"].int,
                           let message = json["message"].string {
                            if code == 200 {
                                if let data = json["data"].dictionaryObject {
                                    single(.success(data))
                                }
                                else
                                if let data = json.dictionaryObject {
                                    single(.success(data))
                                }
                            } else {
                                single(.error(DNAPIError.log(code: code, message: message)))
                            }
                        }
                    } catch ( let _e ) {
                        single(.error(_e))
                    }
                }
            }
            return Disposables.create { }
        }
        .observeOn(MainScheduler.instance)
    }

    private func requestObject<T: Mappable>(_ target: DNAPITarget, type: T.Type) -> Single<T> {
        return Single.create { single in
            DispatchQueue.global().async {
                self.moya.request(target) { (result) in
                    do {
                        let response = try result.get()
                        let json = try JSON.init(data: response.data)
                        //log.debug(json)
                        if let data = json["data"].dictionaryObject {
                            guard let object = T.init(JSON: data) else {
                                single(.error(DNAPIError.cannotCastData))
                                return }
                            single(.success(object))
                        } else {
                            if let code = json["code"].int,
                               let message = json["message"].string {
                                single(.error(DNAPIError.log(code: code, message: message)))
                            }
                        }
                    } catch ( let _e ) {
                        single(.error(_e))
                    }
                }
            }
            return Disposables.create { }
        }
        .observeOn(MainScheduler.instance)
    }

    private func requestArray<T: Mappable>(_ target: DNAPITarget, type: T.Type) -> Single<[T]> {
        return Single.create { single in
            DispatchQueue.global().async {
                var arrs:[T?] = []
                self.moya.request(target) { (result) in
                    do {
                        let response = try result.get()
                        let json = try JSON.init(data: response.data)
                        //log.debug(json)
                        let datas = json["data"].arrayValue
                        arrs = datas.map({ (j) -> T? in
                            return T.init(JSON: j.dictionaryObject!)
                        })
                        single(.success(arrs.compactMap { $0 }))
                    } catch ( let _e ) {
                        single(.error(_e))
                    }
                }
            }
            return Disposables.create { }
        }
        .observeOn(MainScheduler.instance)
    }

    private func requestDownload(_ target: DNAPITarget) -> Single<Any> {
        return Single.create { single in
            DispatchQueue.global().async {
                self.moya.request(target, callbackQueue: nil, progress: nil) { (result) in
                    switch result {
                    case .success( let data):
                        single(.success("success!"))
                    case .failure( let _error ):
                        single(.error(_error))
                    }
                }

            }
            return Disposables.create { }
        }
        .observeOn(MainScheduler.instance)
    }

}
