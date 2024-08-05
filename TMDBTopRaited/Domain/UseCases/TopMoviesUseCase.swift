import Foundation

protocol TopMoviesUseCase {
    func execute(
        requestValue: TopMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultTopMoviesUseCase: TopMoviesUseCase {

    private let moviesRepository: MoviesRepository

    init(
        moviesRepository: MoviesRepository
    ) {

        self.moviesRepository = moviesRepository
    }

    func execute(
        requestValue: TopMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {

        return moviesRepository.fetchMoviesList(
            page: requestValue.page,
            cached: cached,
            completion: { result in
            completion(result)
        })
    }
}

struct TopMoviesUseCaseRequestValue {
    let page: Int
}
