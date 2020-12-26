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
    
    static func listCategories(_ param: [String:Any], completion: @escaping (ListCategoryRespone?, BaseError?) -> Void) -> Void {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            
            return
        }
        Alamofire.request(ApiRouter.listCategories(param)).responseObject { (response: DataResponse<ListCategoryRespone>) in
            
            switch response.result {
            case .success:
                // print log response
                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if json != nil {
                    print(json!)
                }
                
                if response.response?.statusCode == 200 {
                    completion(response.result.value, nil)
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
    
    static func detailCategory(_ param: [String:Any], completion: @escaping (CategoryDetail?, BaseError?) -> Void) -> Void {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            
            return
        }
        Alamofire.request(ApiRouter.detailCategory(param)).responseObject { (response: DataResponse<CategoryDetail>) in
            
            switch response.result {
            case .success:
                // print log response
                let json = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                if json != nil {
                    print(json!)
                }
                
                if response.response?.statusCode == 200 {
                    completion(response.result.value, nil)
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
    
    static func downloadFile(fileURL: URL, fileName: String, completionHandler:@escaping(String, Bool)->()){

        let destinationPath: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let filePath = documentsURL.appendingPathComponent(FolderPath.ringtone + "/" + fileName)
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
        }
    
        Alamofire.download(fileURL, to: destinationPath)
            .downloadProgress { progress in

            }
            .responseData { response in
                print("download response: \(response)")
                switch response.result{
                case .success:
                    if response.destinationURL != nil, let filePath = response.destinationURL?.absoluteString {
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    completionHandler("", false)
                    break
                }

        }
    }

}
