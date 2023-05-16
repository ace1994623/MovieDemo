//
//  ImageDownloadHelper.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/8.
//

import Foundation

class ImageDownloadHelper {
    enum ImageType {
        case poster
    }
    
    enum ImageSize {
        case small
        case big
    }
    // MARK: - Public
    /*
     Get a download Url of a specific image based on a path, size and image type
     */
    static func getImageDownlaodUrlString(path: String, size: ImageSize, type: ImageType) -> String {
        let imageSize = getImageSize(size: size, list: getImageSizeList(type: type))
        if let url = UserDefaults.standard.value(forKey: Constants.Caches.UserDefaultKeys.imageDownloadSecureUrl) as? String {
            return url + imageSize + path
        } else if let url = UserDefaults.standard.value(forKey: Constants.Caches.UserDefaultKeys.imageDownloadUrl) as? String {
            return url + imageSize + path
        } else {
            return ""
        }
    }
    
    private static func getImageSizeList(type: ImageType) -> [String] {
        switch type {
        case .poster:
            if let sizeList = UserDefaults.standard.value(forKey: Constants.Caches.UserDefaultKeys.imageDownloadPosterSizeList) as? [String] {
                return sizeList
            } else {
                return []
            }
        }
    }
    
    private static func getImageSize(size: ImageSize, list: [String]) -> String {
        switch size {
        case .small:
            return list.first ?? ""
            
        case .big:
            return list.last ?? ""
        }
    }
}
