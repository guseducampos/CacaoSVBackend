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
    }
    
    func currentSpeakers(_ request: Request) throws -> Future<[Profile]> {
        return Meetup.query(on: request).filter(\.statusID == Status.scheduled.rawValue).first()
            .flatMap { meetup -> Future<[Profile]> in
                guard let meetup = meetup else {
                    throw Abort(.notFound)
                }
                return try meetup.talks.query(on: request).all().flatMap { talks -> Future<[Profile]> in
                    return talks.map { $0.speaker.get(on: request) }.flatten(on: request)
                }
        }
    }
}
