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
