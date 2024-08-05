import Foundation

// MARK: - Data Transfer Object

struct MoviesResponseDTO: Decodable {
  private enum CodingKeys: String, CodingKey {
    case page
    case totalPages = "total_pages"
    case movies = "results"
  }
  let page: Int
  let totalPages: Int
  let movies: [MovieDTO]
}

extension MoviesResponseDTO {
  struct MovieDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
      case id
      case title
      case posterPath = "poster_path"
      case backdropPath = "backdrop_path"
      case overview
      case releaseDate = "release_date"
      case voteAverage = "vote_average"
      
    }
    
    let id: Int
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
  }
}

// MARK: - Mappings to Domain

extension MoviesResponseDTO {
  func toDomain() -> MoviesPage {
    return .init(page: page,
                 totalPages: totalPages,
                 movies: movies.map { $0.toDomain() })
  }
}

extension MoviesResponseDTO.MovieDTO {
  func toDomain() -> Movie {
    return .init(id: Movie.Identifier(id),
                 title: title,
                 posterPath: posterPath,
                 backdropPath: backdropPath,
                 overview: overview,
                 releaseDate: dateFormatter.date(from: releaseDate ?? ""),
                 voteAverage: voteAverage?.rounded() ?? 0.0)
  }
}
// MARK: - Private

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  return formatter
}()
