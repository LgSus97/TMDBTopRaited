import Foundation
import CoreData

extension MoviesResponseEntity {
    func toDTO() -> MoviesResponseDTO {
        return .init(
            page: Int(page),
            totalPages: Int(totalPages),
            movies: movies?.allObjects.map { ($0 as! MovieResponseEntity).toDTO() } ?? []
        )
    }
}

extension MovieResponseEntity {
    func toDTO() -> MoviesResponseDTO.MovieDTO {
        return .init(
            id: Int(id),
            title: title,
            posterPath: posterPath, 
            backdropPath: backdropPath,
            overview: overview,
            releaseDate: releaseDate,
            voteAverage: voteAverage
        )
    }
}

extension MoviesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesRequestEntity {
        let entity: MoviesRequestEntity = .init(context: context)
        entity.page = Int32(page)
        return entity
    }
}

extension MoviesResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesResponseEntity {
        let entity: MoviesResponseEntity = .init(context: context)
        entity.page = Int32(page)
        entity.totalPages = Int32(totalPages)
        movies.forEach {
            entity.addToMovies($0.toEntity(in: context))
        }
        return entity
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toEntity(in context: NSManagedObjectContext) -> MovieResponseEntity {
        let entity: MovieResponseEntity = .init(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.posterPath = posterPath
        entity.overview = overview
        entity.releaseDate = releaseDate
        return entity
    }
}
