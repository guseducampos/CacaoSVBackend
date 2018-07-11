//
//  MeetupStatusSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL


struct MeetupStatusSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let scheduled = MeetupStatus(id: nil, name: "Scheduled", createdAt: nil)
        let done = MeetupStatus(id: nil, name: "Done", createdAt: nil)
        let cancelled = MeetupStatus(id: nil, name: "Cancelled", createdAt: nil)
        let inProgress = MeetupStatus(id: nil, name: "In Progress", createdAt: nil)
        return [scheduled.save(on: conn), done.save(on: conn),cancelled.save(on: conn), inProgress.save(on: conn)].flatten(on: conn).map {_ in ()}
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
    
}
