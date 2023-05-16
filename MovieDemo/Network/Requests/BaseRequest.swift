//
//  BaseRequest.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

class BaseRequest {
    // MARK: - Public
    /*
     Base requset function, allow subclass to call after set specific paramters and headers
     */
    static func request<T: Decodable>(url: String?,
                                      parameters: [String: Any]? = nil,
                                      headers: [String: String]? = nil,
                                      modelClass: T.Type,
                                      success: @escaping MovieNetworkManager.CompletionHandler,
                                      failure: @escaping MovieNetworkManager.CompletionHandler) {
        // Send request
        MovieNetworkManager.shared.getRequest(urlString: url ?? "",
                                              parameters: addDefaultParams(paramters: parameters),
                                              headers: addDefaultHeaders(headers: headers),
                                              modelClass: modelClass,
                                              success: success,
                                              failure: failure)
    }
    
    /*
      Add default params to a given params, and allow override the default params
     */
    private static func addDefaultParams(paramters: [String: Any]?) -> [String: Any] {
        var res : [String: Any] = ["api_key" : Constants.Network.Keys.moviesAPIKey]
        if let params = paramters {
            for (key, value) in params {
                res[key] = value
            }
        }
        return res
    }
    
    /*
     Add default headers to a given headers, and allow override the default headers
     */
    private static func addDefaultHeaders(headers: [String: String]?) -> [String: String] {
        var res : [String: String] = [:]
        if let heads = headers {
            for (key, value) in heads {
                res[key] = value
            }
        }
        return res
    }
}



