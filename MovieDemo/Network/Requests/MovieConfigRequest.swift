//
//  MovieConfigRequest.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

class MovieConfigRequest : BaseRequest {
    // MARK: - Public
    /*
     Request the image downloading config
     */
    static func requestConfig(networkManager: NetworkRequestProtocol) {
        let url = Constants.Network.Domains.moviesDomain
        + Constants.Network.URLs.configurationPath
        
        self.request(url: url,
                     networkManager: networkManager,
                     modelClass: MoviesConfigModel.self)
        { responseModel, error in
            if let model = responseModel as? MoviesConfigModel {
                // Save to cache
                saveConfigs(model: model)
            }
        } failure: { responseModel, error in
            // print log if failed
            print("[MovieDemo] MovieConfigRequest - failed")
        }
    }
    
    // MARK: - Private
    /*
     Save config to UserDefaults
     */
    private static func saveConfigs(model: MoviesConfigModel) {
        // Save the image download Url
        UserDefaults.standard.set(model.images?.baseUrl,
                                  forKey: Constants.Caches.UserDefaultKeys.imageDownloadUrl)
        // Save the image secure Url
        UserDefaults.standard.set(model.images?.secureBaseUrl,
                                  forKey: Constants.Caches.UserDefaultKeys.imageDownloadSecureUrl)
        // Save the image poster size list
        UserDefaults.standard.set(model.images?.posterSizes,
                                  forKey: Constants.Caches.UserDefaultKeys.imageDownloadPosterSizeList)
    }
}
