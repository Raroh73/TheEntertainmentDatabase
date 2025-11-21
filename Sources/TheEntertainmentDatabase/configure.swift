import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Leaf
import Vapor

public func configure(_ app: Application) async throws {
    switch app.environment {
    case .testing:
        app.databases.use(.sqlite(.memory), as: .sqlite)
    case .development:
        app.databases.use(.sqlite(.file("database.sqlite")), as: .sqlite)
    case .production:
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: Environment.get("DB_HOSTNAME") ?? "localhost",
                    username: Environment.get("DB_USERNAME") ?? "username",
                    password: Environment.get("DB_PASSWORD") ?? "password"
                )
            ),
            as: .psql)
    default:
        throw "Environment not set!"
    }
    app.migrations.add(CreateMovies())
    try await app.autoMigrate()

    app.views.use(.leaf)

    try routes(app)
}
