//
//  MovieListModel.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

struct MoviesListModel : Decodable {
    // MARK: - Properties
    // The current page of movie list
    let page: Int?
    // The number of movie list
    let totalResults: Int?
    // The number of page of the movie list
    let totalPages: Int?
    // Name of the movie
    let results: [MoviesInfoModel]?

    
    // MARK: - Coding Keys
    /*
     Mapping the properties to the response json to retrive data from response
     */
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        results = try container.decodeIfPresent(Array.self, forKey: .results)
    }
    
    init(page: Int?,
         totalResults: Int?,
         totalPages: Int?,
         results: [MoviesInfoModel]?) {
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = results
    }
}
