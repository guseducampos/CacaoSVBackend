//
//  ProfileController.swift
//  App
//
//  Created by  LaptopGCampos on 8/23/18.
//

import Vapor
import FluentPostgreSQL

struct ProfileController: RouteCollection {
    
    func boot(router: Router) throws {
        let publicRoutes = router.grouped("profile")
        publicRoutes.get("communityMembers", use: communityMembers)
    }
    
    func communityMembers(_ request: Request) throws -> Future<[Profile]> {
        return Profile.profiles(ofType: .community, on: request)
        
    }
}
