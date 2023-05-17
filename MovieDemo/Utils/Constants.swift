//
//  Constants.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

enum Constants {
    // MARK: - Network Constants
    enum Network {
        /*
         The network request domains
         */
        enum Domains {
            static let moviesDomain = "https://api.themoviedb.org/3"
        }
        
        /*
         The network request URLs
         */
        enum URLs {
            static let moviesListPath = "/search/movie"
            static let configurationPath = "/configuration"
        }
        
        /*
         Keys for network request
         */
        enum Keys {
            /// API key is from https://www.themoviedb.org/settings/api
            static let moviesAPIKey = "1de1f3d9b69c7daff82a668c86729ca2"
        }
    }
    
    // MARK: - Caches Constants
    enum Caches {
        /*
         The Keys of UserDefault
         */
        enum UserDefaultKeys {
            static let moviesInfoPageSize = "moviesInfoPageSize"
            static let imageDownloadUrl = "imageDownloadUrl"
            static let imageDownloadSecureUrl = "imageDownloadSecureUrl"
            static let imageDownloadPosterSizeList = "imageDownloadPosterSizeList"
        }
    }
    
    // MARK: - Database
    enum Database {
        /*
         The Keys of Database
         */
        enum DatabaseKeys {
            static let databaseName = "MovieDemo"
        }
        
        /*
         The Keys of Entities
         */
        enum EntityKeys {
            static let moviesInfoEntityName = "MoviesInfo"
        }
        
        /*
         The Keys of FetchRequest
         */
        enum Request {
            static let defaultPageSize = 10
        }
    }
    
    // MARK: - Strings
    enum Strings {
        /*
         The Keys of Database
         */
        enum FavoriteButton {
            static let add = "Add favorite"
            static let remove = "Remove favorite"
            static let jumpToFavoriteList = "Favorite List"
        }
    }
    
    // MARK: - Errors
    enum Errors {
        /*
         Error code
         */
        enum Code {
            /// UnknowError
            static let unknowError = -10000
            /// Invalid Url
            static let invalidUrl = -10001
            /// Fail to parse parameters
            static let invalidParameter = -10002
            /// Fail to convert response to model
            static let invalidResponse = -10003
            /// Response from server is empty
            static let emptyResponse = -10004
            /// Fail to fetch result remotely
            static let netWorkError = -10005
            /// Fail to fetch result remotely, use the local result
            static let netWorkErrorWithLocalResuslt = -10006
            /// User search with empth word or word only contains space
            static let emptyKeywordError = -20001
        }
        
        /*
         Error message
         */
        enum Msg {
            static let unknowError = "Error when fetching result, please try another Keyword"
            static let invalidUrl = "Error when fetching result, please try another Keyword"
            static let invalidParameter = "Error when fetching result, please try another Keyword"
            static let invalidResponse = "Server error, please try again later"
            static let emptyResponse = "No result, please change another keyword"
            static let netWorkError = "Network error, and there's no local result, please check your network connection and try again later"
            static let netWorkErrorWithLocalResuslt = "Get data through offline mode, due to network issue"
            static let emptyKeywordError = "Not allow to search with keyword only contains space, please change another keyword"
        }
    }
}
