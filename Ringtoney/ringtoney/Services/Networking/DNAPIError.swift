//
//  DNAPIError.swift
//  ringtoney
//
//  Created by dong ka on 10/29/20.
//

import Foundation
import Alamofire

enum DNAPIError: Error {
    case log( code: Int, message: String)
    case cannotCastData
}
