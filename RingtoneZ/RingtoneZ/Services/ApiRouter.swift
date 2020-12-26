//
//  ApiService.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case listCategories([String: Any])
    case detailCategory([String: Any])
    
    // Http method
    private var method: HTTPMethod {
        switch self {
        case .listCategories:
            return .get
        case .detailCategory:
            return .get
        }
    }
    
    // path
    private var path: String {
        switch self {
        case .listCategories:
            return "api/categories"
        case .detailCategory(let param):
            return "api/categories/\(param["cateID"] as! String)/ringtones"
        }
    }
    
    // paramater
    private var parameters: Parameters? {
        switch self {
        case .listCategories(let paramater):
            return paramater
        case .detailCategory(let paramater):
            return paramater
        }
    }
    
    // URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Network.baseUrl)?.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url!)

        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let encoding = JSONEncoding.default
        let encoding = URLEncoding.queryString
        print("URL: ", try encoding.encode(urlRequest, with: parameters))
        return try encoding.encode(urlRequest, with: parameters)
//        return urlRequest
    }
}

