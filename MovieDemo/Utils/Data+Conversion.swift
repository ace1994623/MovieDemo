//
//  Data+Conversion.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/11.
//

import Foundation

extension Data {
    /*
     Convert json data to a given model class, return nil if convert failed
     */
    func mapToModel<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch let error as DecodingError {
            print("[MovieDemo] Data - `mapToModel` failed to decode: \(error.localizedDescription)")
            return nil
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
