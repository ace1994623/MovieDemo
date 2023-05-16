//
//  ImageView+SDWebImage.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/11.
//

import UIKit

extension UIImageView {
    // MARK: - Public
    /*
     Set image with string
     */
    func setImage(urlString: String, completion: @escaping () -> Void){
        // Check if already have image in database
        if let posterImage = getImageFromeDatabase(urlString: urlString) {
            self.image = posterImage
            completion()
        } else if let url = URL(string: urlString) {
            self.sd_setImage(with: url, completed: { image, error, cacheType, url in
                completion()
                // Save to database
                if let img = image {
                    self.saveImageToDatabase(urlString: urlString, imageData:  img.jpegData(compressionQuality: 1.0))
                }
            })
        }
    }
    
    // MARK: - Core Data
    /*
     Save image to database
     */
    private func saveImageToDatabase(urlString: String, imageData: Data?) {
        if let data = imageData {
            CoreDataManager.shared.insertPosterImage(url: urlString, imageData: data)
        }
        
    }
    
    /*
     Get image from database if the image is exist
     */
    private func getImageFromeDatabase(urlString: String) -> UIImage? {
        return UIImage.sd_image(with: CoreDataManager.shared.searchPosterImage(url: urlString))
    }
}
