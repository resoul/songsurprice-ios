import Foundation

public struct TabItem: Equatable {
    public let id: String
    public let title: String
    public let icon: String          // SF Symbol name
    public let genres: [GenreItem]

    public init(id: String, title: String, icon: String, genres: [GenreItem] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.genres = genres
    }
}
