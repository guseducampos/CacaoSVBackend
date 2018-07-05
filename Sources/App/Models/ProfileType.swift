//
//  ProfileType.swift
//  App
//
//  Created by  LaptopGCampos on 7/4/18.
//

import FluentPostgreSQL

struct ProfileType: PostgreSQLModel {
    
    var id: Int?
    
    var name: String
    
    var createdAt: Date?
    
    static let createdAtKey: TimestampKey? = \.createdAt
}

extension ProfileType {
    
    var profiles: Siblings<ProfileType, Profile, ProfileTypePivot> {
        return siblings()
    }
}

extension ProfileType: Migration {}
