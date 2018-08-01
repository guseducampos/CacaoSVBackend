//
//  Future+Extensions.swift
//  App
//
//  Created by  LaptopGCampos on 7/26/18.
//

import Vapor

extension Future {
    
    func toVoid() -> EventLoopFuture<Void> {
        return self.map { _ in ()}
    }
}

extension Future where Expectation: Collection {
    
    func isEmpty(abort: @escaping @autoclosure () -> Error) -> Future<Expectation> {
        return self.map { collection in
            guard !collection.isEmpty else {
                throw abort()
            }
            return collection
        }
    }
}
