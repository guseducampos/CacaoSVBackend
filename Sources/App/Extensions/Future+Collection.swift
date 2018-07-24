//
//  Future+Collection.swift
//  App
//
//  Created by  LaptopGCampos on 7/24/18.
//

import Vapor

extension Future where T: Collection {
    
    func whenIsEmpty(_ error: Error) -> Future<T> {
        return self.map { array in
            guard !array.isEmpty else {
                throw error
            }
            return array
        }
    }
}
