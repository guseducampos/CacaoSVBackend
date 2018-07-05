//
//  MeetupStatus.swift
//  App
//
//  Created by Gustavo Campos on 7/1/18.
//

import FluentPostgreSQL

struct MeetupStatus: PostgreSQLModel {
    
    var id: Int?
    
    var name: String
    
    var createdAt: Date?
    
    static let createdAtKey: TimestampKey? = \.createdAt
}

extension MeetupStatus {
    var meetups: Children<MeetupStatus, Meetup> {
        return children(\.statusID)
    }
    
}

extension MeetupStatus: Migration {}


