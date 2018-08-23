//
//  Router+Extension.swift
//  App
//
//  Created by  LaptopGCampos on 8/23/18.
//

import Vapor

extension Router {
    func register(collection: RouteCollection...) throws {
        try collection.forEach { try $0.boot(router: self) }
    }
}
