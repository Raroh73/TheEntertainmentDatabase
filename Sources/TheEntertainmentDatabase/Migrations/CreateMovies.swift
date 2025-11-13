import Fluent

struct CreateMovies: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("movies")
            .id()
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .field("title", .string, .required)
            .field("year", .int, .required)
            .field("description", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("movies").delete()
    }
}
