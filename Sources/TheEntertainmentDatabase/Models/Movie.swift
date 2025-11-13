import Fluent

final class Movie: Model, @unchecked Sendable {
    static let schema = "movies"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Field(key: "title")
    var title: String

    @Field(key: "year")
    var year: Int

    @Field(key: "description")
    var description: String

    init() {}

    init(
        id: UUID? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, deletedAt: Date? = nil,
        title: String, year: Int, description: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.title = title
        self.year = year
        self.description = description
    }
}
