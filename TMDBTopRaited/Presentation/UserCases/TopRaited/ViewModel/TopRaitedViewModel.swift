//
//  TopRaitedViewModel.swift
//  TMDB
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import Foundation

struct MoviesListViewModelClosures {
  let showMovieDetails: (Movie) -> Void
}

enum MoviesListViewModelLoading {
  case fullScreen
  case nextPage
}

protocol MoviesListViewModelInput {
  func viewDidLoad()
  func didLoadNextPage()
  func didRetrieveMovies()
  func didSelectItem(at indexPath: IndexPath)
}

protocol MoviesListViewModelOutput {
  var error: Observable<String> { get }
  var isEmpty: Bool { get }
  var screenTitle: String { get }
  var errorTitle: String { get }
  var reloadItems: Observable<Bool> { get }
  func numberOfItems(in section: Int) -> Int
  func item(for indexPath: IndexPath) -> MoviesListItemViewModel
}

typealias MoviesListViewModel = MoviesListViewModelInput & MoviesListViewModelOutput

final class DefaultMoviesListViewModel: MoviesListViewModel {
  
  private let topMoviesUseCase: TopMoviesUseCase
  private let closures: MoviesListViewModelClosures?
  
  var currentPage: Int = 0
  var totalPageCount: Int = 1
  var hasMorePages: Bool { currentPage < totalPageCount }
  var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
  
  private var pages: [MoviesPage] = [] { didSet { reloadItems.value = true } }
  private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
  private let mainQueue: DispatchQueueType
  
  // MARK: - OUTPUT
  var error: Observable<String> = Observable("")
  var isEmpty: Bool { return pages.movies.isEmpty }
  let screenTitle = NSLocalizedString("Movies", comment: "")
  let errorTitle = NSLocalizedString("Error", comment: "")
  let reloadItems: Observable<Bool> = Observable(true)
  // MARK: - Init
  
  init(
    topMoviesUseCase: TopMoviesUseCase,
    closures: MoviesListViewModelClosures? = nil,
    mainQueue: DispatchQueueType = DispatchQueue.main
  ) {
    self.topMoviesUseCase = topMoviesUseCase
    self.closures = closures
    self.mainQueue = mainQueue
  }
  
  // MARK: - Private
  
  private func appendPage(_ moviesPage: MoviesPage) {
    currentPage = moviesPage.page
    totalPageCount = moviesPage.totalPages
    
    pages = pages
      .filter { $0.page != moviesPage.page }
    + [moviesPage]
  }
  
  private func resetPages() {
    currentPage = 0
    totalPageCount = 1
    pages = []
  }
  
  private func load() {
    moviesLoadTask = topMoviesUseCase.execute(
      requestValue: .init(page: nextPage),
      cached: { [weak self] page in
        self?.mainQueue.async {
          self?.appendPage(page)
        }
      },
      completion: { [weak self] result in
        self?.mainQueue.async {
          switch result {
          case .success(let page):
            self?.appendPage(page)
          case .failure(let error):
            self?.handle(error: error)
          }
        }
      }
    )
  }
  
  private func handle(error: Error) {
    self.error.value = error.isInternetConnectionError ?
    NSLocalizedString("No internet connection", comment: "") :
    NSLocalizedString("Failed loading movies", comment: "")
  }
  
  private func update() {
    resetPages()
    load()
  }
  
  // MARK: - INPUT. View event methods
  
  func viewDidLoad() {
    update()
  }
  
  func didLoadNextPage() {
    guard hasMorePages else { return }
    load()
  }
  
  func didRetrieveMovies() {
    update()
  }
  
  func didSelectItem(at indexPath: IndexPath) {
    closures?.showMovieDetails(pages.movies[indexPath.row])
  }
}

// MARK: - Private

private extension Array where Element == MoviesPage {
  var movies: [Movie] { flatMap { $0.movies } }
}

// MARK: - OUTPUT. View event methods

extension DefaultMoviesListViewModel {
  
  func item(for indexPath: IndexPath) -> MoviesListItemViewModel {
    return .init(movie: pages.movies[indexPath.row])
  }
  
  func numberOfItems(in section: Int) -> Int {
    return pages.movies.count
  }
}
