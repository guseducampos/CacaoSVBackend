//
//  QueryBuilder+Extensions.swift
//  App
//
//  Created by  LaptopGCampos on 7/26/18.
//

import Fluent

extension QueryBuilder {
    
    func unwrapFirst(or error: Error) -> Future<Result> {
        return self.first().unwrap(or: error)
    }
}
