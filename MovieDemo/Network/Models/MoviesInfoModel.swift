//
//  MoviesInfoModel.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit

struct MoviesInfoModel : Decodable {
    // MARK: - Properties
    // The address of the poster of the movie
    let posterPath: String?
    // Overview of the movie
    let overview: String?
    // Release date of the movie
    let releaseDate: String?
    // Name of the movie
    let title: String?
    // Name of the movie
    let id: Int?
    // Show if the movie is marked as favorite by user
    var isFavorite: Bool

    
    // MARK: - Coding Keys
    /*
     Mapping the properties to the response json to retrive data from response
     */
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
        case title = "title"
        case id = "id"
    }
    
    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        isFavorite = false
    }
    
    init(posterPath: String?,
         overview: String?,
         releaseDate: String?,
         title: String?,
         id: Int,
         isFavorite: Bool) {
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.title = title
        self.id = id
        self.isFavorite = isFavorite
    }
    
    
    // MARK: - CoreData
    /*
     Convert model to a dictionary to use NSBatchInsertRequest
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["posterPath"] = posterPath
        dictionary["overview"] = overview
        dictionary["releaseDate"] = releaseDate
        dictionary["title"] = title
        dictionary["id"] = id
        dictionary["isFavorite"] = isFavorite
        return dictionary
    }
}
