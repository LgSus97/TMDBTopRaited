import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
  func makeMoviesListViewController(
    closures: MoviesListViewModelClosures
  ) -> TopRaitedViewController
  func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
}

final class MoviesSearchFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: MoviesSearchFlowCoordinatorDependencies
  private weak var moviesListVC: TopRaitedViewController?
  
  init(navigationController: UINavigationController,
       dependencies: MoviesSearchFlowCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  func start() {
    // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
    let closures = MoviesListViewModelClosures(showMovieDetails: showMovieDetails)
    let vc = dependencies.makeMoviesListViewController(closures: closures)
    navigationController?.pushViewController(vc, animated: false)
  }
  
  private func showMovieDetails(movie: Movie) {
    let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
    navigationController?.pushViewController(vc, animated: true)
  }
}
