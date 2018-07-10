//
//  Profile.swift
//  App
//
//  Created by  LaptopGCampos on 7/4/18.
//

import Vapor
import FluentPostgreSQL

struct Profile: PostgreSQLModel {
    
    var id: Int?
    
    var name: String
    
    var lastname: String
    
    var email: String?
    
    var password: String?
    
    var currentJob: String?
    
    var profileDescription: String
    
    var gitProfile: String?
    
    var twitter: String?
    
    var linkedin: String?
    
    var createdAt: Date?
    
    static let createdAtKey: TimestampKey? = \.createdAt
    
     static let IdKey: IDKey = \.id
    
}

extension Profile {
    
    var profileTypes: Siblings<Profile, ProfileType, ProfileTypePivot> {
        return siblings()
    }
    
    var talks: Children<Profile, Talk> {
        return children(\.meetupId)
    }
}

extension Profile: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
             builder.unique(on: \.email)
            
        }
    }
}
extension Profile: Content {}

extension Profile: Parameter {}
