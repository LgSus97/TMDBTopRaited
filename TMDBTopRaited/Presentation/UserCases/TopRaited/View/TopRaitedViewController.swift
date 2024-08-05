//
//  TopRaitedViewController.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import UIKit

final class TopRaitedViewController: UIViewController {
  
   private var topTitle: UILabel = {
    LabelFactory(
      withMessage: "\(NSLocalizedString("Movies", comment: ""))",
      textColor: STColors.cleanWhite,
      style: .bold,
      fontSize: 18,
      textAlignment: .center
    ).create() as! UILabel
  }()
  
  private var tableView : UITableView = {
    var table = UITableView()
    table.backgroundColor = STColors.snowWhite
    table.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.90)
    return table
  }()
  
  private var viewModel: MoviesListViewModel!
  private var posterImagesRepository: PosterImagesRepository?
  
  
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
    viewModel.reloadItems.observe(on: self) { [weak self] _ in self?.updateItems() }
  }
  
  private func setUI() {
    self.navigationItem.titleView = topTitle
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
    tableView.addAnchorsWithMargin(0)
  }
  
  private func updateItems() {
    tableView.reloadData()
  }
  
}

extension TopRaitedViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
        fatalError("Unable to dequeue MovieTableViewCell")
    }
  
    cell.fill(with: viewModel.item(for: indexPath), posterImagesRepository: posterImagesRepository)
    cell.selectionStyle = .none
    
    if indexPath.row == viewModel.numberOfItems(in: indexPath.section) - 1 {
      viewModel.didLoadNextPage()
    }
  
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath)
  }
}
