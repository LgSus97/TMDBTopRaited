//
//  DetailsViewController.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

class DetailsViewController: UIViewController {
  
  var scrollView : UIScrollView = {
      var scrollView = UIScrollView()
      scrollView.backgroundColor = STColors.cleanWhite
      return scrollView
  }()
  
  
  var optionTitle : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20,
      textAlignment: .center
    ).create() as! UILabel
  }()
  
  var overViewLabel : UILabel = {
    LabelFactory(
      textColor: STColors.stormySea,
      style: .medium,
      fontSize: 18,
      textAlignment: .justified
    ).create() as! UILabel
  }()
  
  var releaseLabel : UILabel = {
    LabelFactory(
      textColor: STColors.stormySea,
      style: .regular,
      fontSize: 16
    ).create() as! UILabel
  }()
  
  var raitingLabel : UILabel = {
    LabelFactory(
      textColor: STColors.stormySea,
      style: .regular,
      fontSize: 16
    ).create() as! UILabel
  }()
  
  private var movieView : UIImageView = {
    var image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  var stackView : UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 8
    return stack
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
    setupViews()
    bind(to: viewModel)
    // Do any additional setup after loading the view.
  }
  
  private func bind(to viewModel: MovieDetailsViewModel) {
    viewModel.posterImage.observe(on: self) { [weak self] in
      guard let self = self else { return }
      let image = $0.flatMap(UIImage.init)
      DispatchQueue.main.async {
        self.movieView.image = image
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      viewModel.updatePosterImage(width: Int(movieView.imageSizeAfterAspectFit.scaledSize.width))
  }
  
  // MARK: - Private
  private func setupViews() {
    view.addSubview(scrollView)
    scrollView.addAnchorsWithMargin(0)
    self.scrollView.addSubview(movieView)
    movieView.addAnchorsAndSize(
      width: width - 20,
      height: height/3,
      left: 10,
      top: 10,
      right: 10,
      bottom: nil)
    self.scrollView.addSubview(stackView)
    
    let labels = [optionTitle, overViewLabel, releaseLabel, raitingLabel]
    for label in labels {
        stackView.addArrangedSubview(label)
    }
    self.stackView.addAnchors(
      left: 20,
      top: 10,
      right: 20,
      bottom: nil,
      withAnchor: .top,
      relativeToView: movieView)
    
    optionTitle.text = viewModel.title
    overViewLabel.text = viewModel.overview
    releaseLabel.text = viewModel.releaseDate
    raitingLabel.text = viewModel.voteAverage
  }
  
}
