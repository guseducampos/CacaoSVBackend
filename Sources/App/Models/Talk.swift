//
//  Talk.swift
//  App
//
//  Created by  LaptopGCampos on 7/4/18.
//

import FluentPostgreSQL
import Vapor

struct Talk: PostgreSQLModel {
    
    var id: Int?
    
    var meetupId: Meetup.ID
    
    var speakerId: Profile.ID
    
    var topic: String
    
    var description: String
    
    var createdAt: Date?
    
    static let createdAtKey: TimestampKey? = \.createdAt
}

extension Talk {
    
    var speaker: Parent<Talk, Profile> {
        return parent(\.speakerId)
    }
    
    var meetup: Parent<Talk, Meetup> {
        return parent(\.meetupId)
    }
    
}

extension Talk: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.meetupId, to: \Meetup.id)
             builder.reference(from: \.speakerId, to: \Profile.id)
        }
    }
}

extension Talk: Content {}
