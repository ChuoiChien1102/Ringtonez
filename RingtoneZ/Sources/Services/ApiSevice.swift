//
//  ApiSevice.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiSevice {
    static func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func login(_ param: [String:Any], completion: @escaping (LoginRespone?, BaseError?) -> Void) -> Void {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            
            return
        }
        Alamofire.request(ApiRouter.login(param)).responseObject { (response: DataResponse<LoginRespone>) in
            
            switch response.result {
            case .success:
                // print log response
                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if json != nil {
                    print(json!)
                }
                
                if response.response?.statusCode == 200 {
                    if (response.result.value?.error_code == "0") {
                        completion(response.result.value, nil)
                    } else {
                        let err: BaseError = BaseError.init(NetworkErrorType.API_ERROR, Int(response.result.value!.error_code!)!, (response.result.value?.message)!)
                        completion(nil, err)
                    }
                } else {
                    let err: BaseError = BaseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, ERROR_CONNECTION.ERROR_HTTP_REQUEST)
                    completion(nil, err)
                }
                break
                
            case .failure(let error):
                let err: BaseError = BaseError.init(NetworkErrorType.HTTP_ERROR, error._code, ERROR_CONNECTION.ERROR_HTTP_REQUEST)
                completion(nil, err)
                break
            }
        }
    }

}
