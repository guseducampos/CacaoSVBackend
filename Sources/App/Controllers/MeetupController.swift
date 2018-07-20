//
//  ProfileController.swift
//  App
//
//  Created by  LaptopGCampos on 7/9/18.
//

import Vapor
import Fluent

struct MeetupController: RouteCollection {
    
    func boot(router: Router) throws {
        let publicRoutes = router.grouped("api", "meetup")
        publicRoutes.get("currentSpeakers", use: currentSpeakers)
        publicRoutes.get("currentMeetup", use: currentMeetup)
    }
    
    func currentSpeakers(_ request: Request) throws -> Future<[Profile]> {
        return try getMeetup(byStatus: .scheduled, on: request).flatMap { meetup -> Future<[Profile]> in
            return try meetup.talks.query(on: request).all().flatMap { talks in
                guard !talks.isEmpty else {
                   throw Abort(.notFound)
                }
                return talks.map { $0.speaker.get(on: request) }.flatten(on: request)
            }
        }
    }
    
    func currentMeetup(_ request: Request) throws -> Future<Meetup> {
        return try getMeetup(byStatus: .scheduled, on: request)
    }
    
    private func getMeetup(byStatus status: Status, on request: Request) throws -> Future<Meetup> {
        return  Meetup.query(on: request).filter(\.statusID == status.rawValue).first().map { meetup in
            guard let meetup = meetup else {
                throw Abort(.notFound)
            }
            return meetup
        }
    }
}
