//
//  MovieTableViewCell.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  
  var movieView : UIImageView = {
    var image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  var optionTitle : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20
    ).create() as! UILabel
  }()
  
  var optionSubtitle : UILabel = {
    LabelFactory(
      textColor: STColors.mistyBlue,
      style: .semibold,
      fontSize: 18
    ).create() as! UILabel
  }()
  
  var optionContent : UIView = {
    var view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 5
    return view
  }()
  
  var stackView : UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()
  
  let topLineView = UIView()
  let bottomLineView = UIView()
  
  var viewModel: MoviesListItemViewModel?
  private var posterImagesRepository: PosterImagesRepository?
  private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func fill(with viewModel: MoviesListItemViewModel, posterImagesRepository: PosterImagesRepository?) {
    self.viewModel = viewModel
    self.posterImagesRepository = posterImagesRepository
    optionTitle.text = viewModel.title
    optionSubtitle.text = viewModel.releaseDate
    updatePosterImage(width: Int(movieView.imageSizeAfterAspectFit.scaledSize.width))
  }
  
  func initUI(){
    self.contentView.addSubview(optionContent)
    optionContent.addAnchorsWithMargin(10)
    optionContent.addSubview(movieView)
    
    stackView.addArrangedSubview(optionTitle)
    stackView.addArrangedSubview(optionSubtitle)
    optionContent.addSubview(stackView)
        
    movieView.addAnchorsAndSize(width: 120,
                                 height: 120,
                                 left: 10,
                                 top: 10,
                                 right: nil,
                                 bottom: 10)
    
    stackView.addAnchorsAndCenter(centerX: false,
                                  centerY: true,
                                  width: nil,
                                  height: nil,
                                  left: 15,
                                  top: nil,
                                  right: 35,
                                  bottom: nil, withAnchor: .left, relativeToView: movieView)
    
    
    
    topLineView.backgroundColor = STColors.lightBreeze
    bottomLineView.backgroundColor = STColors.lightBreeze
    
    self.addSubview(topLineView)
    self.addSubview(bottomLineView)
        
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let lineWidth: CGFloat = 0.25
    let lineMargin: CGFloat = 20.0
    
    topLineView.frame = CGRect(x: lineMargin, y: 0, width: self.bounds.width - 2 * lineMargin, height: lineWidth)
    bottomLineView.frame = CGRect(x: lineMargin, y: self.bounds.height - lineWidth, width: self.bounds.width - 2 * lineMargin, height: lineWidth)
  }
  
  private func updatePosterImage(width: Int) {
    movieView.image = nil
    guard let posterImagePath = viewModel?.posterImagePath else { return }
    
    imageLoadTask = posterImagesRepository?.fetchImage(with: posterImagePath, width: width) { [weak self] result in
      guard let self = self else { return }
      guard self.viewModel?.posterImagePath == posterImagePath else { return }
      if case let .success(data) = result {
        DispatchQueue.main.async {
          self.movieView.image = UIImage(data: data)
        }
      }
      self.imageLoadTask = nil
    }
  }
  
}
