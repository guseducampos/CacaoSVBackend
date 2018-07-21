//
//  MeetupTest.swift
//  App
//
//  Created by  LaptopGCampos on 7/12/18.
//

@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

final class MeetupTest: BaseTest {
    
    func testCurrentMeetupSpeakers() throws {
        let profiles = try app.getRequest(to: "/api/meetup/currentSpeakers", method: .GET, decodeTo: [Profile].self)
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles.first?.name, "Gustavo")
    }
    
    func testEmptyCurrentMeetupSpeakers() throws {
        //For testing, always the profile with id 1 will be set for into the current meetup
        //check ProfileSeed, TalkSeed and MeetupSeed
        _ = try Meetup(id: nil, statusID:2, name: "test2", eventDate: Date(), createdAt: nil).save(on: conn).wait()
        var talk = try Talk.query(on: conn).filter(\.id == 1).first().unwrap(or: Abort(.notFound)).wait()
        talk.meetupId = 2
        _ = try talk.update(on: conn).wait()
        let response = try app.sendRequest(to: "/api/meetup/currentSpeakers", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    func testCurrentMeetup() throws {
        let meetup = try app.getRequest(to: "/api/meetup/currentMeetup", method: .GET, decodeTo: Meetup.self)
        XCTAssertEqual(meetup.id, 1)
        XCTAssertEqual(meetup.statusID, 1)
    }
    
    func testEmptyMeetup() throws {
        var meetup =  try Meetup.query(on: conn).filter(\.statusID ==  Status.scheduled.rawValue).first().unwrap(or: Abort(.notFound)).wait()
        meetup.statusID = Status.done.rawValue
        _ =  try meetup.update(on: conn).wait()
        let response = try app.sendRequest(to: "/api/meetup/currentMeetup", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    func testCurrentTalks() throws {
        let talk = try app.getRequest(to: "/api/meetup/currentTalks", method: .GET, decodeTo: [Talk].self).first
        XCTAssertEqual(talk?.id, 1)
        XCTAssertEqual(talk?.speakerId, 1)
    }
    
    func testEmptyCurrentMeetupTalks() throws {
        _ =  try Meetup.query(on: conn).filter(\.statusID ==  Status.scheduled.rawValue).first().unwrap(or: Abort(.notFound)).flatMap { meetup -> Future<[Talk]> in
            return try meetup.talks.query(on: self.conn).all()
            }.flatMap { talks -> Future<Void> in
                return talks.map { $0.delete(on: self.conn)}.flatten(on: self.conn)
            }.wait()
        let response = try app.sendRequest(to: "/api/meetup/currentTalks", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    
    static let allTests = [
        ("testCurrentMeetupSpeakers", testCurrentMeetupSpeakers),
        ("testEmptyCurrentMeetupSpeakers", testEmptyCurrentMeetupSpeakers),
        ("testCurrentMeetup", testCurrentMeetup),
        ("testEmptyMeetup", testEmptyMeetup),
        ("testCurrentTalks", testCurrentTalks),
        ("testEmptyCurrentMeetupTalks", testEmptyCurrentMeetupTalks)
    ]
}
