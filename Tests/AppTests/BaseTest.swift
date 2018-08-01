//
//  BaseTest.swift
//  AppTests
//
//  Created by  LaptopGCampos on 7/17/18.
//
@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

class BaseTest: XCTestCase {
    
    var app: Application!
    var conn: PostgreSQLConnection!
    
    override func setUp() {
       try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }
    
    override func tearDown() {
        conn.close()
    }
    
    func reset() throws {
        try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }
    
}
