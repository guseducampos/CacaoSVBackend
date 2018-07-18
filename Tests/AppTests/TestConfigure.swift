//
//  TestConfigure.swift
//  App
//
//  Created by  LaptopGCampos on 7/12/18.
//

@testable import App
import Vapor
import FluentPostgreSQL


/// Called before your application initializes.
public func testConfigure(_ config: inout Config,
                          _ env: inout Environment,
                          _ services: inout Services) throws {
    
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    // Configure a Postgres database
    
  
    let postgres = PostgreSQLDatabaseConfig(hostname: Environment.get("TEST_POSTGRES_HOST") ?? "localhost",
                                            port: Int(Environment.get("TEST_POSTGRES_PORT") ?? "") ?? 5433,
                                            username: Environment.get("TEST_POSTGRES_USER") ?? "test",
                                            database: Environment.get("TEST_POSTGRES_DATABASE") ?? "CacaoSVTest",
                                            password: Environment.get("TEST_POSTGRES_PASSWORD") ?? "test")
    
    /// Register the configured PostgreSQL database to the database config.
    let database = PostgreSQLDatabase(config: postgres)
    var databases = DatabasesConfig()
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: MeetupStatus.self, database: .psql)
    migrations.add(model: Meetup.self, database: .psql)
    migrations.add(model: ProfileType.self, database: .psql)
    migrations.add(model: Profile.self, database: .psql)
    migrations.add(model: Talk.self, database: .psql)
    migrations.add(model: ProfileTypePivot.self, database: .psql)
    
    /// Seeds
    
    migrations.add(migration: MeetupStatusSeed.self, database: .psql)
    migrations.add(migration: MeetupSeed.self, database: .psql)
    migrations.add(migration: ProfileTypeSeed.self, database: .psql)
    migrations.add(migration: ProfileSeed.self, database: .psql)
    migrations.add(migration: ProfileTypePivotSeed.self, database: .psql)
    migrations.add(migration: TalkSeed.self, database: .psql)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    
    services.register(migrations)
}
