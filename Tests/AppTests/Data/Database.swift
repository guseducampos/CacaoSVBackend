//
//  Meetup+TestData.swift
//  AppTests
//
//  Created by  LaptopGCampos on 8/1/18.
//

@testable import App
import Vapor
import FluentPostgreSQL

// This is a workaround for don't use migration for test, since for some reason are broken, you can check on branch bugged-migration
// I'll check after finish all of the app features. I still don't sure if is a bug from my side or fluent.

extension Meetup {
    
    static func make(on conn: DatabaseConnectable) -> Future<Meetup> {
        let meetup = Meetup(id: nil, statusID: 1, name: "test", eventDate: Date(), createdAt: nil)
        return meetup.save(on: conn)
    }
    
    static func remove<T: Encodable>(where key: KeyPath<Meetup, T> , has value: T, on conn: DatabaseConnectable) -> Future<Void> {
        return Meetup.query(on: conn).filter(\.statusID == 1).delete()
    }
}


extension ProfileTypePivot {
    
    static func makeSpeaker(on conn: DatabaseConnectable) -> Future<ProfileTypePivot> {
        return make(profileType: 1, on: conn)
    }
    
    static func make(profileType: Int,  on conn: DatabaseConnectable) -> Future<ProfileTypePivot> {
        return Profile.query(on: conn).first().flatMap { profiles -> Future<ProfileTypePivot> in
            guard let profile = profiles else {
                throw Abort(.notFound)
            }
            return try ProfileTypePivot(id: nil, profileId: profile.requireID(), profileTypeId: profileType, createdAt: nil).save(on: conn)
        }
    }
}

extension Profile {
    
    static func make(on conn: DatabaseConnectable) -> Future<Profile> {
        let profile = Profile(id: nil,
                              name: "Gustavo", lastname: "Campos", email: "guseducampos@gmail.com",
                              password: nil, currentJob: "iOS Developer",
                              profileDescription: "iOS dev", gitProfile: "test",
                              twitter: "test", linkedin: "test", createdAt: nil)
        return profile.save(on: conn)
    }
    
}


extension Talk {
    
    static func make(on conn: DatabaseConnectable) -> Future<Talk> {
        return flatMap(to: Talk.self, getSpeaker(on: conn), getMeetup(on: conn)) { (profile, meetup) -> Future<Talk> in
            return Talk(id: nil, meetupId: try meetup.requireID(), speakerId: try profile.requireID(), topic: "Swift", description: "Programming Language", createdAt: nil).save(on: conn)
        }
    }
    
    private static func getSpeaker(on conn: DatabaseConnectable) -> Future<Profile> {
        return ProfileType.query(on: conn).filter(\.id == 1).unwrapFirst(or: Abort(.notFound)).flatMap { profileType in
            return try  profileType.profiles.query(on: conn).unwrapFirst(or: Abort(.notFound))
        }
    }
    
    private static func getMeetup(on conn: DatabaseConnectable) -> Future<Meetup> {
        return Meetup.query(on: conn).unwrapFirst(or: Abort(.notFound))
    }
}

