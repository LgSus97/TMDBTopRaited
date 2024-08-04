//
//  TopRaitedViewModel.swift
//  TMDB
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import Foundation


struct MoviesListViewModelActions {
    //let showMovieDetails: (Movie) -> Void
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
  //var items: Observable<[MoviesListItemViewModel]> { get }
  var loading: Observable<MoviesListViewModelLoading?> { get }
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
  
  

    private let searchMoviesUseCase: SearchMoviesUseCase
    private let actions: MoviesListViewModelActions?

  var currentPage: Int = 0
  var totalPageCount: Int = 1
  var hasMorePages: Bool { currentPage < totalPageCount }
  var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

 // private var pages: [MoviesPage] = []
  private var pages: [MoviesPage] = [] { didSet { reloadItems.value = true } }

  private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
  private let mainQueue: DispatchQueueType

    // MARK: - OUTPUT

  //var items: Observable<[MoviesListItemViewModel]> = Observable([])
  var loading: Observable<MoviesListViewModelLoading?> = Observable(.none)
  var error: Observable<String> = Observable("")
  //var isEmpty: Bool { return items.value.isEmpty }
  var isEmpty: Bool { return pages.movies.isEmpty }
  let screenTitle = NSLocalizedString("Movies", comment: "")
  let errorTitle = NSLocalizedString("Error", comment: "")
  let reloadItems: Observable<Bool> = Observable(true)
    // MARK: - Init
    
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        actions: MoviesListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }

    // MARK: - Private

    private func appendPage(_ moviesPage: MoviesPage) {
        currentPage = moviesPage.page
        totalPageCount = moviesPage.totalPages

        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

      //items.value = pages.movies.map(MoviesListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
//        pages.removeAll()
//      items.value.removeAll()
      pages = []
    }

    private func load(loading: MoviesListViewModelLoading) {
      self.loading.value = loading

        moviesLoadTask = searchMoviesUseCase.execute(
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
                  self?.loading.value = .none
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
        load(loading: .fullScreen)
    }

    // MARK: - INPUT. View event methods

    func viewDidLoad() {
       update()
    }

  func didLoadNextPage() {
      guard hasMorePages, loading.value == .none else { return }
      load(loading: .nextPage)
  }

    func didRetrieveMovies() {
        update()
    }

//    func didSelectItem(at index: Int) {
//       // actions?.showMovieDetails(pages.movies[index])
//    }
  
  func didSelectItem(at indexPath: IndexPath) {
      //closures?.showMovieDetails(pages.movies[indexPath.row])
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
