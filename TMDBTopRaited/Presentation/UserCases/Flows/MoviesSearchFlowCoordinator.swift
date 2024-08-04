import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListViewController(
        actions: MoviesListViewModelActions
    ) -> TopRaitedViewController
   // func makeMoviesDetailsViewController(movie: Movie) -> UIViewController

}

final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    private weak var moviesListVC: TopRaitedViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesListViewModelActions()
        let vc = dependencies.makeMoviesListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
//
//    private func showMovieDetails(movie: Movie) {
//        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
