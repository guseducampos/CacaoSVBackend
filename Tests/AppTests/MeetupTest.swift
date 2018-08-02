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
        let response = try app.sendRequest(to: "/api/meetup/currentSpeakers", method: .GET)
        let profiles = try response.content.decode([Profile].self).wait()
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles.first?.name, "Gustavo")
    }
    
    func testEmptyCurrentMeetupSpeakers() throws {
        let meetup = try Meetup(id: nil, statusID:2, name: "test2", eventDate: Date(), createdAt: nil).save(on: conn).wait()
        var talk = try Talk.query(on: conn).unwrapFirst(or: Abort(.notFound, reason: "there are no talks")).wait()
        talk.meetupId = try meetup.requireID()
        _ = try talk.update(on: conn).wait()
        let response = try app.sendRequest(to: "/api/meetup/currentSpeakers", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    func testCurrentMeetup() throws {
        let meetup = try app.getRequest(to: "/api/meetup/currentMeetup", method: .GET, decodeTo: Meetup.self)
        XCTAssertEqual(meetup.name, "test")
        XCTAssertEqual(meetup.statusID, 1)
        try reset()
    }
    
    func testEmptyMeetup() throws {
        var meetup =  try Meetup.query(on: conn).filter(\.statusID ==  Status.scheduled.rawValue).unwrapFirst(or: Abort(.notFound)).wait()
        meetup.statusID = Status.done.rawValue
        _ =  try meetup.update(on: conn).wait()
        let response = try app.sendRequest(to: "/api/meetup/currentSpeakers", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    static let allTests = [
        ("testCurrentMeetupSpeakers", testCurrentMeetupSpeakers),
        ("testEmptyCurrentMeetupSpeakers", testEmptyCurrentMeetupSpeakers),
        ("testCurrentMeetup", testCurrentMeetup),
        ("testEmptyMeetup", testEmptyMeetup)
    ]
}
