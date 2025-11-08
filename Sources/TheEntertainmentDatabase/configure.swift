import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("database.sqlite")), as: .sqlite)
    try await app.autoMigrate()

    try routes(app)
}
