//
//  Application+Test.swift
//  AppTests
//
//  Created by  LaptopGCampos on 7/13/18.
//

@testable import App
import Vapor

extension Application {
    
    struct EmptyContent: Content {}
    
    static func testableWithRevertedMigrations() throws -> Application {
        return try testable(arguments:  ["vapor", "revert", "--all", "-y"])
    }
    
    static func testable(arguments: [String] = []) throws -> Application {
        var config = Config.default()
        var services = Services.default()
        var enviroment = Environment.testing
        enviroment.arguments = arguments
        try testConfigure(&config, &enviroment, &services)
        let app = try Application(config: config, environment: enviroment, services: services)
        try App.boot(app)
        return app
    }
    
    
    func sendRequest<T: Content>(to path: String, method: HTTPMethod, headers: HTTPHeaders = HTTPHeaders(), body: T? = nil) throws -> Response {
        let responder = try self.make(Responder.self)
        let request = HTTPRequest(method: method, url: URL(string: path)!, headers: headers)
        let wrappedRequest = Request(http: request, using: self)
        
        if let body = body {
            try wrappedRequest.content.encode(body)
        }
        return try responder.respond(to: wrappedRequest).wait()
    }
    
    func sendRequest(to path: String, method: HTTPMethod, headers: HTTPHeaders = HTTPHeaders()) throws -> Response {
        let empty: EmptyContent? = nil
        return try sendRequest(to: path, method: method, headers: headers, body: empty)
    }
    
    func getRequest<T: Content,C: Decodable>(to path: String, method: HTTPMethod, headers: HTTPHeaders = HTTPHeaders(), data: T?, decodeTo type: C.Type ) throws -> C {
        let response = try sendRequest(to: path, method: method, headers: headers, body: data)
        return try response.content.decode(type).wait()
    }
    
    
    func getRequest<C: Decodable>(to path: String, method: HTTPMethod, headers: HTTPHeaders = HTTPHeaders(), decodeTo type: C.Type ) throws -> C {
        let response = try sendRequest(to: path, method: method, headers: headers, body: EmptyContent())
        return try response.content.decode(type).wait()
    }
}
