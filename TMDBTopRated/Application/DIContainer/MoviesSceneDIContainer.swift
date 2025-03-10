//
//  MoviesSceneDIContainer.swift
//  TMDB
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import Foundation
import UIKit

final class MoviesSceneDIContainer: TopMoviesFlowCoordinatorDependencies {
  
  struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageDataTransferService: DataTransferService
  }
  
  private let dependencies: Dependencies
  
  // MARK: - Persistent Storage
  lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Use Cases
  func makeTopMoviesUseCase() -> TopMoviesUseCase {
    DefaultTopMoviesUseCase(
      moviesRepository: makeMoviesRepository()
    )
  }
  
  // MARK: - Repositories
  func makeMoviesRepository() -> MoviesRepository {
    DefaultMoviesRepository(
      dataTransferService: dependencies.apiDataTransferService,
      cache: moviesResponseCache
    )
  }
  
  func makePosterImagesRepository() -> PosterImagesRepository {
    DefaultPosterImagesRepository(
      dataTransferService: dependencies.imageDataTransferService
    )
  }
  
  // MARK: - Movies List
  func makeMoviesListViewController(closures: MoviesListViewModelClosures) -> TopRaitedViewController {
    TopRaitedViewController.create(
      with: makeMoviesListViewModel(closures: closures),
      posterImagesRepository: makePosterImagesRepository()
    )
  }
  
  func makeMoviesListViewModel(closures: MoviesListViewModelClosures) -> MoviesListViewModel {
    DefaultMoviesListViewModel(
      topMoviesUseCase: makeTopMoviesUseCase(),
      closures: closures
    )
  }
  
  // MARK: - Movie Details
  func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
    DetailsViewController.create(
      with: makeMoviesDetailsViewModel(movie: movie)
    )
  }
  
  func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
    DefaultMovieDetailsViewModel(
      movie: movie,
      posterImagesRepository: makePosterImagesRepository()
    )
  }
  
  // MARK: - Flow Coordinators
  func makeTopMoviesFlowCoordinator(navigationController: UINavigationController) -> TopMoviesFlowCoordinator {
    TopMoviesFlowCoordinator(
      navigationController: navigationController,
      dependencies: self
    )
  }
}
