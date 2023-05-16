//
//  CoreDataManager.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/12.
//

import CoreData
import UIKit

class CoreDataManager {
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    // Data base name
    private let modelName = Constants.Database.DatabaseKeys.databaseName
    
    // Container
    var persistentContainer: NSPersistentContainer
    
    // Context of core data
    var context: NSManagedObjectContext
    
    // MARK: - Initializers
    private init() {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("[MovieDemo] CoreDataManager - `init` Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
    }
    
    
    
    // MARK: - Public
    /*
     Save changes in context
     */
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("[MovieDemo] CoreDataManager - `saveContext` Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - MoviesInfo
    /*
     Save all MoviesInfoModel from list
     */
    func batchInsertMoviesInfoList(list: [MoviesInfoModel]) {
        
        // Create a batch insert request
        let batchInsertRequest = NSBatchInsertRequest(
            entity: MoviesInfoEntity.entity(),
            objects: list.map {$0.toDictionary()}
        )
        
        // Insert all entities
        do {
            try context.execute(batchInsertRequest)
        } catch let error as NSError {
            print("[MovieDemo] CoreDataManager - `batchInsertMoviesInfoList` Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    /*
     Search MoviesInfoModel based on provide keyword and page number, and return a list
     (Page size Limitation can be defined in constants for now)
     */
    func searchMoviesInfoList(keyWord: String, page: Int) -> MoviesListModel? {
        let fetchRequest: NSFetchRequest<MoviesInfoEntity> = MoviesInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", keyWord)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            let pageSize = UserDefaults.standard.value(forKey: Constants.Caches.UserDefaultKeys.moviesInfoPageSize) as? Int ?? Constants.Database.Request.defaultPageSize
            // Config page info
            let start = (page - 1) * pageSize
            let end = min(page * pageSize, results.count)
            // Config the MoviesListModel, get sub array of result based on page
            return MoviesListModel(page: page,
                                   totalResults: results.count,
                                   totalPages: results.count / pageSize + 1,
                                   results: results[start..<end].map{$0.toMoviesInfoModel()})
            
        } catch let error {
            print("[MovieDemo] CoreDataManager - `searchMoviesInfoList` Failed to fetch: \(error)")
            return nil
        }
    }
    
    /*
    Get all movies marked as favorite
    */
   func getFavoriteMovieList() -> [MoviesInfoModel] {
       let fetchRequest: NSFetchRequest<MoviesInfoEntity> = MoviesInfoEntity.fetchRequest()
       fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true as NSNumber)
       
       do {
           let results = try persistentContainer.viewContext.fetch(fetchRequest)
           // Config the MoviesListModel, get sub array of result based on page
           return results.map{$0.toMoviesInfoModel()}
           
       } catch let error {
           print("[MovieDemo] CoreDataManager - `getFavoriteMovieList` Failed to fetch: \(error)")
           return []
       }
   }
    
    /*
     Check if a specific movie is marked as favorite
     */
    func checkIsFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MoviesInfoEntity> = MoviesInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
                return result.isFavorite
            } else {
                return false
            }
        } catch let error {
            print("[MovieDemo] CoreDataManager - `checkIsFavorite` Failed to fetch: \(error)")
            return false
        }
    }
    
    /*
     Change the FavoriteStatus
     */
    func changeFavoriteStatus(id: Int) {
        let fetchRequest: NSFetchRequest<MoviesInfoEntity> = MoviesInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
                result.isFavorite = !result.isFavorite
                saveContext()
            }
        } catch let error {
            print("[MovieDemo] CoreDataManager - `changeFavoriteStatus` Failed to fetch: \(error)")
        }
    }
    
    // MARK: - Images
    /*
     Save image to database
     */
    func insertPosterImage(url: String, imageData: Data) {
        // Create a PosterImageEntity
        let imageEntity = PosterImageEntity(context: context)
        imageEntity.url = url
        imageEntity.image = imageData

        // Save to database
        saveContext()
    }
    
    /*
     Get image from database
     */
    func searchPosterImage(url: String) -> Data? {
        let fetchRequest: NSFetchRequest<PosterImageEntity> = PosterImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest).first {
                return result.image
            } else {
                return nil
            }
        } catch let error {
            print("[MovieDemo] CoreDataManager - `searchPosterImage` Failed to fetch: \(error)")
            return nil
        }
    }
}
