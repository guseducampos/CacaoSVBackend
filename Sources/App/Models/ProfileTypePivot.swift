//
//  ProfileTypePivot.swift
//  App
//
//  Created by  LaptopGCampos on 7/4/18.
//

import FluentPostgreSQL
import Vapor

struct ProfileTypePivot: PostgreSQLUUIDPivot {
    
    typealias Left = Profile
    
    typealias Right = ProfileType
    
    var id: UUID?
    
    var profileId: Profile.ID
    
    var profileTypeId: ProfileType.ID
    
    var createdAt: Date?
    
    static let createdAtKey: TimestampKey? = \.createdAt
    
    static var leftIDKey: LeftIDKey = \.profileId
    
    static var rightIDKey: RightIDKey = \.profileTypeId

}

extension ProfileTypePivot: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.profileId, to: \Profile.id)
            builder.reference(from: \.profileTypeId, to:\ProfileType.id)
        }
    }
    
}
