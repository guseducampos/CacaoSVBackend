//
//  ProfileController.swift
//  App
//
//  Created by  LaptopGCampos on 7/23/18.
//

import Vapor
import FluentPostgreSQL

struct ProfileController: RouteCollection {
    
    func boot(router: Router) throws {
        let publicRoutes = router.grouped("profile")
        publicRoutes.get("communityMembers", use: communityMembers)
    }
    
    func communityMembers(_ request: Request) throws -> Future<[Profile]> {
        return ProfileType.query(on: request).filter(\.id == ProfileTypes.community.rawValue)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { profileType in return try profileType.profiles.query(on: request).all() }
            .whenIsEmpty(Abort(.notFound))
        
    }
}
