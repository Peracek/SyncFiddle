//
//  APIRouter.swift
//  SyncFiddle
//
//  Created by Pavel Peroutka on 02/10/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    static var baseURL = "http://localhost:8080"
    
    case Skills
    
    func asURLRequest() throws -> URLRequest {
        let path: String = {
            switch self {
            case .Skills:
                return "skills"
            }
        }()
        
        var url = URL(string: APIRouter.baseURL)!
        url.appendPathComponent(path)
        return URLRequest(url: url)
    }
}
