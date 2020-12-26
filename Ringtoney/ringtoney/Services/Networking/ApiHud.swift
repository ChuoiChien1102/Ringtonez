//
//  ApiHud.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

//MARK:- Provider
let AwesomeProvider = MoyaProvider<DNAPITarget>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter)))])

// Without logger
//let DMVProvider = MoyaProvider<DmvHubAPI>()

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

/* Định nghia đường dẫn lưu file */
private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

enum DNAPITarget {

    case download(url: URL, fileName: String?)
    case listCategories( page: Int)
    case topCategories( page: Int)
    case detailCategory( cateId: Int, page: Int)
    case search( key: String, page: Int)
}

extension DNAPITarget : TargetType {


    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return url
        default:
            return URL(string: Configs.Network.baseUrl)!
        }
    }

    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .search:
            return "/api/ringtones/search"
        case .detailCategory(cateId: let cateID, page: _):
            return "api/categories/\(cateID)/ringtones"
        case .topCategories:
            return "api/categories/top-categories"
        case .listCategories:
            return "api/categories"
        case .download: return ""
        }
    }


    // Here we specify which method our calls should use.
    public var method: Moya.Method {
        switch self {
//        case :
//            return .post
        default:
            return .get
        }
    }

    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    // In this example we will not pass anything in the body of the request.
    public var task: Task {
        switch self {
        case .download:
            return .downloadDestination(downloadDestination)
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }

    // These are the headers that our service requires.
    // Usually you would pass auth tokens here.
    var headers: [String: String]? {

        switch self {
        case .download:
            return nil
        default: return nil
        }
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        
        params["app"] = "y"
        
        switch self {
        case .search(let keySearch, let page):
            params["name"] = keySearch
            params["page"] = page
        case.detailCategory( _ , let page):
            params["page"] = page
        case .topCategories(let page):
            params["page"] = page
        case .listCategories(let page):
            params["page"] = page
        default: break
        }
        return params
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {

        //If usign post method
//        case :
//            return URLEncoding.queryString

        //If usign get method
        default:
            return URLEncoding.default
        }

    }

    var localLocation: URL {
        switch self {
        case .download(_, let fileName):
            if let fileName = fileName {
//                return assetDir.appendingPathComponent(fileName)
                log.debug("Path: \(Configs.FolderPath.ringtone + "/" + fileName)")
                return assetDir.appendingPathComponent(Configs.FolderPath.ringtone + "/" + fileName)
            }
        default: break
        }
        return assetDir
    }

    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }

    // This is sample return data that you can use to mock and test your services,
    // but we won't be covering this.
    var sampleData: Data {
        return Data()
    }

}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
