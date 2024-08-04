//
//  MovieTableViewCell.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  
  var moviesListItemViewModel: MoviesListItemViewModel
  
  var deletePush:(() -> Void)?
  
  var action:(() -> Void)?
  
  var optionIcon : UIImageView = {
    var image = UIImageView()
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  var optionTitle : UILabel = {
    LabelFactory(textColor: STColors.oceanDeep, style: .bold, fontSize: 18).create() as! UILabel
  }()
  
  var optionSubtitle : UILabel = {
    LabelFactory(textColor: STColors.oceanDeep, style: .bold, fontSize: 18).create() as! UILabel
  }()
  
  var optionContent : UIView = {
    var view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 5
    return view
  }()
  
  
  var iconDelete : UIImageView = {
    var image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.isUserInteractionEnabled = true
    return image
  }()
  
  
  var stackView : UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()
  
  let topLineView = UIView()
  let bottomLineView = UIView()
  
  init(moviesListItemViewModel: MoviesListItemViewModel){
    self.moviesListItemViewModel = moviesListItemViewModel
    super.init(style: .default, reuseIdentifier: nil)
    self.backgroundColor = .white
    initUI()
    setTapped()
  }
  
  func initUI(){
    self.contentView.addSubview(optionContent)
    optionContent.addAnchorsWithMargin(10)
    optionContent.addSubview(optionIcon)
    
    stackView.addArrangedSubview(optionTitle)
    stackView.addArrangedSubview(optionSubtitle)
    optionContent.addSubview(stackView)
    optionContent.addSubview(iconDelete)
    
    iconDelete.addAnchorsAndSize(width: 24,
                                 height: 24,
                                 left: 5,
                                 top: 10,
                                 right: 5,
                                 bottom: nil,
                                 withAnchor: .left,
                                 relativeToView: stackView)
    
    optionIcon.addAnchorsAndSize(width: 36,
                                 height: 36,
                                 left: 10,
                                 top: 10,
                                 right: nil,
                                 bottom: nil)
    
    stackView.addAnchorsAndCenter(centerX: false,
                                  centerY: true,
                                  width: nil,
                                  height: nil,
                                  left: 15,
                                  top: 10,
                                  right: 35,
                                  bottom: 10, withAnchor: .left, relativeToView: optionIcon)
    
    
    
    topLineView.backgroundColor = STColors.lightBreeze
    bottomLineView.backgroundColor = STColors.lightBreeze
    
    // Añadir las líneas como subvistas a la celda
    self.addSubview(topLineView)
    self.addSubview(bottomLineView)
    
    
    optionIcon.image = UIImage(systemName: "film.circle")
    optionTitle.text = moviesListItemViewModel.title
    optionSubtitle.text = moviesListItemViewModel.releaseDate
    
    iconDelete.image = UIImage(systemName: "star.circle.fill")
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconDeleteTapped))
    iconDelete.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let lineWidth: CGFloat = 0.25
    let lineMargin: CGFloat = 20.0
    
    topLineView.frame = CGRect(x: lineMargin, y: 0, width: self.bounds.width - 2 * lineMargin, height: lineWidth)
    bottomLineView.frame = CGRect(x: lineMargin, y: self.bounds.height - lineWidth, width: self.bounds.width - 2 * lineMargin, height: lineWidth)
  }
  
  @objc func iconDeleteTapped() {
    debugPrint("\(#function)")
    deletePush?()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setTapped(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(MovieTableViewCell.tapFunction))
    optionContent.isUserInteractionEnabled = true
    optionContent.addGestureRecognizer(tap)
  }
  
  @objc func tapFunction(){
    if action != nil{
      action!()
    }
  }
  
}
