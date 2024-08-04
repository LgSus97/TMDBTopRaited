//
//  TopRaitedViewController.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import UIKit

final class TopRaitedViewController: UIViewController {
  
  private var viewModel: MoviesListViewModel!
  private var posterImagesRepository: PosterImagesRepository?
  
  var tableView : UITableView = {
    var table = UITableView()
    table.backgroundColor = STColors.snowWhite
    return table
  }()
  
  
  static func create(
    with viewModel: MoviesListViewModel,
    posterImagesRepository: PosterImagesRepository?
  ) -> TopRaitedViewController {
    let view = TopRaitedViewController()
    view.viewModel = viewModel
    view.posterImagesRepository = posterImagesRepository
    return view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind(to: viewModel)
    viewModel.viewDidLoad()
  }
  
  private func bind(to viewModel: MoviesListViewModel) {
     // viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
    viewModel.reloadItems.observe(on: self) { [weak self] _ in self?.updateItems() }
  }
  
  private func setUI() {
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.addAnchorsWithMargin(0)
  }
  
  private func updateItems() {
    tableView.reloadData()
  }
  
}

extension TopRaitedViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("Movie total: \(viewModel.numberOfItems(in: section))")
    return viewModel.numberOfItems(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let movie = viewModel.item(for: indexPath)
    print();print()
    printIfDebug("Movie: \(movie.title)")
    print();print()
    let cell = MovieTableViewCell(moviesListItemViewModel: movie)
    cell.selectionStyle = .none
    
    if indexPath.row == viewModel.numberOfItems(in: indexPath.section) - 1 {
           viewModel.didLoadNextPage()
       }
    
    return cell
  }
}
