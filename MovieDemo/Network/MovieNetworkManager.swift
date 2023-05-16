//
//  MovieNetworkManager.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/7.
//

import Foundation

protocol NetworkRequestProtocol {
    // MARK: - Typeaias
    /// A typealias for the network request completion blocks
    typealias CompletionHandler = (_ responseModel: Decodable?, _ error: NSError?) -> Void
    
    func shared() -> NetworkRequestProtocol
    
    // MARK: - Method
    func getRequest<T: Decodable>(urlString: String,
                                  parameters: [String: Any]?,
                                  headers: [String: String]?,
                                  modelClass: T.Type,
                                  success: @escaping CompletionHandler,
                                  failure: @escaping CompletionHandler)
    
    func postRequest<T: Decodable>(urlString: String,
                                   parameters: [String: Any]?,
                                   headers: [String: String]?,
                                   modelClass: T.Type,
                                   success: @escaping CompletionHandler,
                                   failure: @escaping CompletionHandler)
}

class MovieNetworkManager : NetworkRequestProtocol {
    // MARK: - Properties
    static let shared = MovieNetworkManager()
    private let session: URLSession
    
    // MARK: - Initializers
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    // MARK: - Public
    func shared() -> NetworkRequestProtocol {
        MovieNetworkManager.shared
    }
    /*
     Perform a GET request to the given URL, with optional query parameters and headers.
     */
    func getRequest<T: Decodable>(urlString: String,
                                  parameters: [String: Any]? = nil,
                                  headers: [String: String]? = nil,
                                  modelClass: T.Type,
                                  success: @escaping CompletionHandler,
                                  failure: @escaping CompletionHandler) {
        
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
     Perform a POST request to the given URL, with optional body parameters and headers.
     */
    func postRequest<T: Decodable>(urlString: String,
                                   parameters: [String: Any]? = nil,
                                   headers: [String: String]? = nil,
                                   modelClass: T.Type,
                                   success: @escaping CompletionHandler,
                                   failure: @escaping CompletionHandler) {
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
    
    /*
     Create session task to send the request
     */
    func sendRequest<T: Decodable>(request: URLRequest,
                                   headers: [String: String]? = nil,
                                   modelClass: T.Type,
                                   success: @escaping CompletionHandler,
                                   failure: @escaping CompletionHandler) {
        var req = request
        // Add headers to the request if they were provided
        if let head = headers {
            for (key, value) in head {
                req.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Create data task to perform the request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response and any errors
            if let err = error {
                DispatchQueue.main.async() {
                    failure(data, err as NSError)
                }
            } else if let jsonData = data {
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
        
        // Start the data task
        task.resume()
    }
}
