import Foundation

struct Movie: Equatable, Identifiable {
  typealias Identifier = String
  
  let id: Identifier
  let title: String?
  let posterPath: String?
  let backdropPath: String?
  let overview: String?
  let releaseDate: Date?
  let voteAverage: Double
  
}

struct MoviesPage: Equatable {
  let page: Int
  let totalPages: Int
  let movies: [Movie]
}
