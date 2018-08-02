//
//  Meetup+Data.swift
//  App
//
//  Created by  LaptopGCampos on 7/26/18.
//

import Vapor
import Fluent

extension Meetup {
    
    static func speakersForMeetup(withStatus status: Status, on request: Request) -> Future<[Profile]> {
        return meetup(byStatus: status, on: request).flatMap { meetup -> Future<[Profile]> in
            let speakers =  try speakersFor(meetup: meetup, on: request)
            return speakers.isEmpty(abort: Abort(.notFound, reason: "There are no speakers"))
        }
    }
    
    static func speakersFor(meetup: Meetup, on request: Request) throws -> Future<[Profile]> {
        return try meetup.talks.query(on: request).all().flatMap { talks -> Future<[Profile]> in
            return talks.map { $0.speaker.get(on: request) }.flatten(on: request)
        }
    }
    
    static func meetup(byStatus status: Status, on request: Request) -> Future<Meetup> {
        return Meetup.query(on: request).filter(\.statusID == status.rawValue).unwrapFirst(or: Abort(.notFound, reason: "there is no meetup with the status \(status)"))
    }
}
