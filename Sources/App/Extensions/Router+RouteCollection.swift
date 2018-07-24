//
//  Router+RouteCollection.swift
//  App
//
//  Created by  LaptopGCampos on 7/24/18.
//

import Vapor

extension Router {
    
    func register(collection: RouteCollection...) throws {
        try collection.forEach { try $0.boot(router: self) }
    }
}
