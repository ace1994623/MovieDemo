//
//  ImageConfigModel.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

struct ImageConfigModel : Decodable {
    // MARK: - Properties
    // Url to download image
    let baseUrl: String?
    // Secure Url to download image
    let secureBaseUrl: String?
    // List of backdrop size
    let backdropSizes: [String]?
    // List of logoSizes size
    let logoSizes: [String]?
    // List of posterSizes size
    let posterSizes: [String]?
    // List of posterSizes size
    let profileSizes: [String]?
    // List of stillSizes size
    let stillSizes: [String]?

    
    // MARK: - Coding Keys
    /*
     Mapping the properties to the response json to retrive data from response
     */
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    
    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseUrl = try container.decodeIfPresent(String.self, forKey: .baseUrl)
        secureBaseUrl = try container.decodeIfPresent(String.self, forKey: .secureBaseUrl)
        backdropSizes = try container.decodeIfPresent(Array.self, forKey: .backdropSizes)
        logoSizes = try container.decodeIfPresent(Array.self, forKey: .logoSizes)
        posterSizes = try container.decodeIfPresent(Array.self, forKey: .posterSizes)
        profileSizes = try container.decodeIfPresent(Array.self, forKey: .profileSizes)
        stillSizes = try container.decodeIfPresent(Array.self, forKey: .stillSizes)
    }
}
