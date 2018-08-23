//
//  Profile+Data.swift
//  App
//
//  Created by  LaptopGCampos on 8/23/18.
//

import Vapor
import FluentPostgreSQL

extension Profile {
    
    static func profiles(ofType type: ProfileTypes, on request: Request) -> Future<[Profile]> {
        return ProfileType.query(on: request).filter(\.id == type.rawValue)
            .unwrapFirst(or: Abort(.notFound))
            .flatMap { try $0.profiles.query(on: request).all() }
            .checkEmpty(or: Abort(.notFound))
    }
}
