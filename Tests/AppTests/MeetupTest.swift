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
        XCTAssertEqual(profiles[0].email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles[0].name, "Gustavo")
    }
    
    func testEmptyCurrentMeetupSpeakers() throws {
        //For testing, always the profile with id 1 will be set for into the current meetup
        //check ProfileSeed and MeetupSeed
        _ = try! Profile.query(on: conn).filter(\.id == 1).delete().wait()
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
        _ = Meetup.query(on: conn).filter(\.statusID ==  Status.scheduled.rawValue).delete()
        let response = try app.sendRequest(to: "/api/meetup/currentSpeakers", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    static let allTests = [
        ("testCurrentMeetupSpeakers", testCurrentMeetupSpeakers)
    ]
}
