//
//  MovieListRequest.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

class MovieListRequest : BaseRequest {
    // MARK: - Public
    /*
     Request the image info list
     */
    static func requestMovieList(query: String,
                                 page: Int = 1,
                                 networkManager: NetworkRequestProtocol,
                                 success: @escaping MovieNetworkManager.CompletionHandler,
                                 failure: @escaping MovieNetworkManager.CompletionHandler) {
        // Config the Url
        let url = Constants.Network.Domains.moviesDomain
        + Constants.Network.URLs.moviesListPath
        
        // Config params
        let params = [
            "query" : query,
            "page" : page
        ] as [String : Any]
        
        // Send request
        self.request(url: url,
                     networkManager: networkManager,
                     parameters: params,
                     modelClass: MoviesListModel.self,
                     success: { responseModel, error in
            // Save resulte
            saveToDatabase(responseModel: responseModel)
            // Call back
            success(responseModel, error)
        }) { responseModel, error in
            if let model = fetchFromDatabase(query: query, page: page),
               model.totalResults ?? 0 > 0 {
                // Fetch from data base if network request failed, and return the result if fetch success
                let error = NSError(domain: Constants.Errors.Msg.netWorkErrorWithLocalResuslt,
                                    code: Constants.Errors.Code.netWorkErrorWithLocalResuslt)
                success(model, error)
            } else {
                // If there's a request error and cannot get result from database, then treat as a network error
                let err = NSError(domain: Constants.Errors.Msg.netWorkError,
                                  code: Constants.Errors.Code.netWorkError)
                failure(responseModel, err)
            }
        }
    }
    
    // MARK: - Movie info
    /*
     Save result to Core Data
     */
    static private func saveToDatabase(responseModel: Decodable?) {
        if let model = responseModel as? MoviesListModel {
            // Save result to Core Data
            CoreDataManager.shared.batchInsertMoviesInfoList(list: model.results ?? [])
            // Save page size
            if model.totalPages ?? 1 > 1 {
                UserDefaults.standard.set(model.results?.count, forKey: Constants.Caches.UserDefaultKeys.moviesInfoPageSize)
            }
            
        }
    }
    
    /*
     Fetch result from Database
     */
    static private func fetchFromDatabase(query: String, page: Int) -> MoviesListModel? {
        return CoreDataManager.shared.searchMoviesInfoList(keyWord: query, page: page)
    }
}
