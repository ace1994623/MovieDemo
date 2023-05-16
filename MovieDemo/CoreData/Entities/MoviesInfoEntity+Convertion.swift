//
//  MoviesInfoEntity+Convertion.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/13.
//

import CoreData

extension MoviesInfoEntity {
    // MARK: - Public
    /*
     Convert to the Model
     */
    func toMoviesInfoModel() -> MoviesInfoModel{
        return MoviesInfoModel(posterPath: posterPath,
                               overview: overview,
                               releaseDate: releaseDate,
                               title: title,
                               id: Int(id),
                               isFavorite: isFavorite)
    }
}
