//
//  JSONDecoderManager.swift
//  BookApp
//
//  Created by 손겸 on 12/27/24.
//

import Foundation
import RxSwift

class JSONDecoderManager {
    static let shared = JSONDecoderManager()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Single<T> {
        return Single.create { single in
            do {
                let decodedObject = try self.decoder.decode(T.self, from: data)
                single(.success(decodedObject))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}

