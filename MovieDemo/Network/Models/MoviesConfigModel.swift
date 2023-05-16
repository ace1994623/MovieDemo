//
//  MoviesConfigModel.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

struct MoviesConfigModel : Decodable {
    // MARK: - Properties
    // The image configs
    let images: ImageConfigModel?
    // The list of change keys which can be useful if you are building an app that consumes data from the change feed.
    let changeKeys: [String]?

    
    // MARK: - Coding Keys
    /*
     Mapping the properties to the response json to retrive data from response
     */
    private enum CodingKeys: String, CodingKey {
        case images = "images"
        case changeKeys = "change_keys"
    }
    
    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        images = try container.decodeIfPresent(ImageConfigModel.self, forKey: .images)
        changeKeys = try container.decodeIfPresent(Array.self, forKey: .changeKeys)
    }
}
