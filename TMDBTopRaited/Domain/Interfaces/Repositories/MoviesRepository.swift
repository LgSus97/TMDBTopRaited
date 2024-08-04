import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMoviesList(
        page: Int,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}
