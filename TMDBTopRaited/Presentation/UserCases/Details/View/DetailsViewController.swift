//
//  DetailsViewController.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

class DetailsViewController: UIViewController {
  
  
  
  var optionTitle : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20
    ).create() as! UILabel
  }()
  
  var overViewTitle : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20
    ).create() as! UILabel
  }()
  
  var releaseTitle : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20
    ).create() as! UILabel
  }()
  
  var raiting : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20
    ).create() as! UILabel
  }()
  
  
  var movieView : UIImageView = {
    var image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  // MARK: - Lifecycle
  private var viewModel: MovieDetailsViewModel!
  
  static func create(with viewModel: MovieDetailsViewModel) -> DetailsViewController {
    let view = DetailsViewController()
    view.viewModel = viewModel
    return view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = STColors.gentleMist
    bind(to: viewModel)
    // Do any additional setup after loading the view.
  }
  
  private func bind(to viewModel: MovieDetailsViewModel) {
    //viewModel.posterImage.observe(on: self) { [weak self] in self?.posterImageView.image = $0.flatMap(UIImage.init) }
  }
  
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      //viewModel.updatePosterImage(width: Int(posterImageView.imageSizeAfterAspectFit.scaledSize.width))
  }
  
  func initUI() {
    
  }
  
  // MARK: - Private

  private func setupViews() {
      title = viewModel.title
//      overviewTextView.text = viewModel.overview
//      posterImageView.isHidden = viewModel.isPosterImageHidden
      view.accessibilityIdentifier = AccessibilityIdentifier.movieDetailsView
  }
  
}
