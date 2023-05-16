//
//  MovieListRequestTests.swift
//  MovieDemoTests
//
//  Created by Li, Jiawen on 2023/5/16.
//

import XCTest
@testable import MovieDemo
import CoreData

final class MovieListRequestTests: XCTestCase {
    
    var movieNetworkManager: MovieNetworkManagerMock!
    let dummyData = Data("dummy data".utf8)
    let dummyError = NSError(domain: "error domain", code: 0, userInfo: nil)
    
    override func setUp() {
        super.setUp()
        movieNetworkManager = MovieNetworkManagerMock.shared
        
        // Delete all content of MoviesInfoEntity in core data
        let fetchRequest = NSFetchRequest<MoviesInfoEntity>(entityName: "MoviesInfoEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try CoreDataManager.shared.context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting objects: \(error)")
        }
        
        do {
            try CoreDataManager.shared.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    override func tearDown() {
        movieNetworkManager = nil
        
        super.tearDown()
    }
    
    func test_request_success() {
        let expectation = XCTestExpectation(description: "Reequset movie list success")
        let query = "success"
        let page = 1
        let expectedResult = getModel(data: successData())
        
        movieNetworkManager.expectedError = nil
        movieNetworkManager.expectedResponseData = successData()
        
        MovieListRequest.requestMovieList(query: query,
                                          page: page,
                                          networkManager: movieNetworkManager)
        { responseModel, error in
            if let model = responseModel as? MoviesListModel {
                XCTAssertEqual(model.page, expectedResult.page)
                XCTAssertEqual(model.totalPages, expectedResult.totalPages)
                XCTAssertEqual(model.totalResults, expectedResult.totalResults)
                XCTAssertEqual(model.results?.count, expectedResult.results?.count)
                XCTAssertNil(error)
                expectation.fulfill()
            } else {
                XCTFail("responseModel should be MoviesListModel")
            }
        } failure: { responseModel, error in
            XCTFail("Failure callback should not be called.")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_request_emptyList() {
        let expectation = XCTestExpectation(description: "Reequset got empty list")
        let query = "empty"
        let page = 1
        
        movieNetworkManager.expectedError = nil
        movieNetworkManager.expectedResponseData = emptyListData()
        
        MovieListRequest.requestMovieList(query: query,
                                          page: page,
                                          networkManager: movieNetworkManager)
        { responseModel, error in
            if let model = responseModel as? MoviesListModel {
                XCTAssertEqual(model.page, 1)
                XCTAssertEqual(model.totalPages, 1)
                XCTAssertEqual(model.totalResults, 0)
                XCTAssertEqual(model.results?.count, 0)
                XCTAssertNil(error)
                expectation.fulfill()
            } else {
                XCTFail("responseModel should be MoviesListModel")
            }
        } failure: { responseModel, error in
            XCTFail("Failure callback should not be called.")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_request_failed_with_offline_mode_success() {
        let expectation = XCTestExpectation(description: "Reequset failed but get data from local database success")
        let query = "success"
        let page = 1
        let expectedResult = getModel(data: successData())
        
        // Save Data to database first
        CoreDataManager.shared.batchInsertMoviesInfoList(list: expectedResult.results!)
        
        movieNetworkManager.expectedError = NSError(domain: "test",
                                                    code: -1)
        
        MovieListRequest.requestMovieList(query: query,
                                          page: page,
                                          networkManager: movieNetworkManager)
        { responseModel, error in
            if let model = responseModel as? MoviesListModel {
                XCTAssertEqual(model.page, expectedResult.page)
                XCTAssertEqual(model.totalPages, expectedResult.totalPages)
                XCTAssertEqual(model.totalResults, expectedResult.totalResults)
                XCTAssertEqual(model.results?.count, expectedResult.results?.count)
                XCTAssertEqual(error?.domain, Constants.Errors.Msg.netWorkErrorWithLocalResuslt)
                XCTAssertEqual(error?.code, Constants.Errors.Code.netWorkErrorWithLocalResuslt)
                expectation.fulfill()
            } else {
                XCTFail("should have a MoviesListModel from Core Data")
            }
            
        } failure: { responseModel, error in
            XCTFail("success failure should not be called.")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_model_convert_failed_with_offline_mode_success() {
        let expectation = XCTestExpectation(description: "Convert resonpse failed but get data from local database success")
        let query = "success"
        let page = 1
        let expectedResult = getModel(data: successData())
        
        // Save Data to database first
        CoreDataManager.shared.batchInsertMoviesInfoList(list: expectedResult.results!)
        
        movieNetworkManager.expectedError = nil
        movieNetworkManager.expectedResponseData = wrongData()
        
        MovieListRequest.requestMovieList(query: query,
                                          page: page,
                                          networkManager: movieNetworkManager)
        { responseModel, error in
            if let model = responseModel as? MoviesListModel {
                XCTAssertEqual(model.page, expectedResult.page)
                XCTAssertEqual(model.totalPages, expectedResult.totalPages)
                XCTAssertEqual(model.totalResults, expectedResult.totalResults)
                XCTAssertEqual(model.results?.count, expectedResult.results?.count)
                XCTAssertEqual(error?.domain, Constants.Errors.Msg.netWorkErrorWithLocalResuslt)
                XCTAssertEqual(error?.code, Constants.Errors.Code.netWorkErrorWithLocalResuslt)
                expectation.fulfill()
            } else {
                XCTFail("should have a MoviesListModel from Core Data")
            }
            
        } failure: { responseModel, error in
            XCTFail("success failure should not be called.")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_request_failed_with_offline_mode_failed() {
        let expectation = XCTestExpectation(description: "Reequset failed and no data in local database")
        let query = "failed"
        let page = 1
        
        movieNetworkManager.expectedError = NSError(domain: "test",
                                                    code: -1)
        
        MovieListRequest.requestMovieList(query: query,
                                          page: page,
                                          networkManager: movieNetworkManager)
        { responseModel, error in
            XCTFail("success failure should not be called.")
        } failure: { responseModel, error in
            XCTAssertNil(responseModel)
            XCTAssertEqual(error?.domain, Constants.Errors.Msg.netWorkError)
            XCTAssertEqual(error?.code, Constants.Errors.Code.netWorkError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Mock Data
    func successData() -> Data{
        let jsonStr = "{\"page\":1,\"results\":[{\"adult\":false,\"backdrop_path\":\"/eHafSIDQsI5Cnzc39q0Y2AkIOzz.jpg\",\"genre_ids\":[99,18],\"id\":1042252,\"original_language\":\"cs\",\"original_title\":\"success1`\",\"overview\":\"overview1\",\"popularity\":0.996,\"poster_path\":\"/1lN8nP4ysvpQ4kfB4gnadhQKaeF.jpg\",\"release_date\":\"2023-01-12\",\"title\":\"success1\",\"video\":false,\"vote_average\":0.0,\"vote_count\":0},{\"adult\":false,\"backdrop_path\":null,\"genre_ids\":[],\"id\":397949,\"original_language\":\"en\",\"original_title\":\"success2\",\"overview\":\"overview2\",\"popularity\":0.6,\"poster_path\":null,\"release_date\":\"1974-01-01\",\"title\":\"success2\",\"video\":false,\"vote_average\":1.5,\"vote_count\":2}],\"total_pages\":1,\"total_results\":2}"
        return jsonStr.data(using: .utf8)!
    }
    
    func emptyListData() -> Data{
        let jsonStr = "{\"page\":1,\"results\":[],\"total_pages\":1,\"total_results\":0}"
        return jsonStr.data(using: .utf8)!
    }
    
    func wrongData() -> Data{
        let jsonStr = "{fdsafadsf}"
        return jsonStr.data(using: .utf8)!
    }
    
    func getModel(data: Data) -> MoviesListModel {
        data.mapToModel(MoviesListModel.self)!
    }
    
}
