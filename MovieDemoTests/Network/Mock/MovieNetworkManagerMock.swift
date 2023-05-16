//
//  MovieNetworkManagerMock.swift
//  MovieDemoTests
//
//  Created by Li, Jiawen on 2023/5/16.
//

import XCTest
@testable import MovieDemo

class MovieNetworkManagerMock : NetworkRequestProtocol {
    // MARK: - Properties
    static let shared = MovieNetworkManagerMock()
    
    // Custom network response data
    var expectedResponseData: Data?
    // Custom network error
    var expectedError: NSError?
    
    // MARK: - Origin
    /*
     Same as MovieNetworkManager
     */
    func getRequest<T>(urlString: String,
                       parameters: [String : Any]?,
                       headers: [String : String]?,
                       modelClass: T.Type,
                       success: @escaping CompletionHandler,
                       failure: @escaping CompletionHandler)
    where T : Decodable {
        // Create the URL and request
        var urlComponents = URLComponents(string: urlString)
        if let para = parameters {
            urlComponents?.queryItems = para.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        guard let url = urlComponents?.url else {
            let error = NSError(domain: Constants.Errors.Msg.invalidUrl,
                                code: Constants.Errors.Code.invalidUrl)
            DispatchQueue.main.async() {
                failure(nil, error)
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        sendRequest(request: request,
                    headers: headers,
                    modelClass: modelClass,
                    success: success,
                    failure: failure)
    }
    
    /*
     Same as MovieNetworkManager
     */
    func postRequest<T>(urlString: String,
                        parameters: [String : Any]?,
                        headers: [String : String]?,
                        modelClass: T.Type,
                        success: @escaping CompletionHandler,
                        failure: @escaping CompletionHandler)
    where T : Decodable {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: Constants.Errors.Msg.invalidUrl,
                                code: Constants.Errors.Code.invalidUrl)
            DispatchQueue.main.async() {
                failure(nil, error)
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add body parameters to the request if they were provided
        if let param = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let error = NSError(domain: Constants.Errors.Msg.invalidParameter,
                                    code: Constants.Errors.Code.invalidParameter)
                DispatchQueue.main.async() {
                    failure(nil, error)
                }
                return
            }
        }
        
        sendRequest(request: request,
                    headers: headers,
                    modelClass: modelClass,
                    success: success,
                    failure: failure)
    }
    
    // MARK: - Mocked
    private init() {}
    
    func shared() -> NetworkRequestProtocol {
        MovieNetworkManagerMock.shared
    }
    
    /*
     Mock function
     */
    func sendRequest<T>(request: URLRequest,
                        headers: [String : String]? = nil,
                        modelClass: T.Type,
                        success: @escaping MovieNetworkManager.CompletionHandler,
                        failure: @escaping MovieNetworkManager.CompletionHandler)
    where T : Decodable {
        DispatchQueue.global(qos: .background).async {
            if let err = self.expectedError {
                DispatchQueue.main.async() {
                    failure(nil, err as NSError)
                }
            } else if let jsonData = self.expectedResponseData {
                // Convert data from response to model if data is not nil
                if let model = jsonData.mapToModel(modelClass) {
                    DispatchQueue.main.async() {
                        success(model, nil)
                    }
                } else {
                    // Model is nil means convert fail
                    let error = NSError(domain: Constants.Errors.Msg.invalidResponse,
                                        code: Constants.Errors.Code.invalidResponse)
                    DispatchQueue.main.async() {
                        failure(nil, error)
                    }
                }
            } else {
                // Response data is nil
                let error = NSError(domain: Constants.Errors.Msg.invalidResponse,
                                    code: Constants.Errors.Code.invalidResponse)
                DispatchQueue.main.async() {
                    failure(nil, error)
                }
            }
        }
    }
}
