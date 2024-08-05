import UIKit

protocol TopMoviesFlowCoordinatorDependencies  {
  func makeMoviesListViewController(
    closures: MoviesListViewModelClosures
  ) -> TopRaitedViewController
  func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
}

final class TopMoviesFlowCoordinator {
  
  private weak var navigationController: UINavigationController?
  private let dependencies: TopMoviesFlowCoordinatorDependencies
  private weak var moviesListVC: TopRaitedViewController?
  
  init(navigationController: UINavigationController,
       dependencies: TopMoviesFlowCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  func start() {
    let closures = MoviesListViewModelClosures(showMovieDetails: showMovieDetails)
    let vc = dependencies.makeMoviesListViewController(closures: closures)
    navigationController?.pushViewController(vc, animated: false)
  }
  
  private func showMovieDetails(movie: Movie) {
    let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
    vc.modalTransitionStyle = .partialCurl
    vc.modalPresentationStyle = .overCurrentContext
    navigationController?.pushViewController(vc, animated: true)
  }
}
