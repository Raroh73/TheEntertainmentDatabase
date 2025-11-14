import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        app.databases.use(.sqlite(.file("database.sqlite")), as: .sqlite)
    }
    app.migrations.add(CreateMovies())
    try await app.autoMigrate()

    app.views.use(.leaf)

    try routes(app)
}
