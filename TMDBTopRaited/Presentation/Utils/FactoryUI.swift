//
//  FactoryUI.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

protocol UIComponent {
    func create() -> UIView
}

class LabelFactory: UIComponent {
  
  private let withMessage: String
  private let textColor: UIColor
  private let style: MontserratFont
  private let fontSize: CGFloat
  private let numberOfLines: Int
  private let lineBreakMode: NSLineBreakMode
  private let textAlignment: NSTextAlignment
  
  init(
    withMessage text: String = "",
    textColor: UIColor = STColors.oceanDeep,
    style: MontserratFont = .regular,
    fontSize: CGFloat = 18,
    numberOfLines: Int = 0,
    lineBreakMode: NSLineBreakMode = .byWordWrapping,
    textAlignment: NSTextAlignment = .left
  ) {
    self.withMessage = text
    self.textColor = textColor
    self.style = style
    self.fontSize = fontSize
    self.numberOfLines = numberOfLines
    self.lineBreakMode = lineBreakMode
    self.textAlignment = textAlignment
  }
  
  func create() -> UIView {
    let label = UILabel()
    label.text = withMessage
    label.textColor = textColor
    label.font = UIFont(name: style.rawValue, size: fontSize)
    label.numberOfLines = numberOfLines
    label.lineBreakMode = lineBreakMode
    label.textAlignment = textAlignment
    return label
  }
}

class ButtonFactory: UIComponent {
  private let withMessage: String
  private let iconName: String?
  
  init(
    withMessage text: String = "",
    iconName: String? = nil
  ) {
    self.withMessage = text
    self.iconName = iconName
  }
  
  func create() -> UIView {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(withMessage, for: .normal)
    button.titleLabel?.setMontserratFont(style: .bold, size: 18, color: STColors.cleanWhite)
    button.backgroundColor = STColors.stormySea
    button.layer.cornerRadius = 25
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    if let iconName = self.iconName, let iconImage = UIImage(systemName: iconName) {
      button.setImage(iconImage, for: .normal)
      button.imageView?.contentMode = .scaleAspectFit
      //button.imageView?.backgroundColor = STColors.cleanWhite
      button.tintColor = STColors.cleanWhite
      button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
      button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    return button
  }
}

class ImageViewFactory: UIComponent {
    func create() -> UIView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
