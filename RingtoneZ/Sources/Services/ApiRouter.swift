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
    case login([String: Any])
    case getTTKD([String: Any])
    case getListRoom([String: Any])
    case searchStaff([String: Any])
    
    // Http method
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getTTKD:
            return .post
        case .getListRoom:
            return .post
        case .searchStaff:
            return .post
        }
    }
    
    // path
    private var path: String {
        switch self {
        case .login:
            return API_LINK_LOGIN_NORMAL
        case .getTTKD:
            return API_LINK_GET_TTKD
        case .getListRoom:
            return API_LINK_GET_LIST_ROOM
        case .searchStaff:
            return API_LINK_GET_SEARCH_STAFF
        }
    }
    
    // paramater
    private var parameters: Parameters? {
        switch self {
        case .login(let paramater):
            return paramater
        case .getTTKD(let paramater):
            return paramater
        case .getListRoom(let paramater):
            return paramater
        case .searchStaff(let paramater):
            return paramater
        }
    }
    
    // URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Bundle.infoPlist.baseURL)?.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: parameters)
    }
}

