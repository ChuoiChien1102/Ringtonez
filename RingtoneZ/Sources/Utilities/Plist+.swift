//
//  Plist+.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation

struct InfoPlist: Decodable {
    let baseURL: String
    let appVersion: String
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "Api base url"
        case appVersion = "CFBundleShortVersionString"
    }
}

extension Bundle {
    static let infoPlist: InfoPlist! = {
        guard let url = main.url(forResource: "Info", withExtension: "plist"), let data = try? Data(contentsOf: url) else { return nil }
        do {
            return try PropertyListDecoder().decode(InfoPlist.self, from: data)
        } catch {
            print("BUG: \(error)")
        }
        return nil
    }()

}
