//
//  MockTopRaitedMovies.swift
//  TMDB
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import Foundation

class MockSearchMoviesUseCase: SearchMoviesUseCase {
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {
        let mockMovies = [
          Movie(id: "1", title: "Movie 1",genre: .adventure,posterPath: "",overview: "Test 1 jeje", releaseDate: Date()),
          Movie(id: "1", title: "Movie 1",genre: .adventure,posterPath: "",overview: "Test 1 jeje", releaseDate: Date()),
          Movie(id: "1", title: "Movie 1",genre: .adventure,posterPath: "",overview: "Test 1 jeje", releaseDate: Date()),
        ]
        let mockMoviesPage = MoviesPage(page: 1, totalPages: 1, movies: mockMovies)
        completion(.success(mockMoviesPage))
        return nil
    }
}

class MockCancellable: Cancellable {
    func cancel() {}
}
