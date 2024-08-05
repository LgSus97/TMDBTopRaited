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
    func create() -> UIView {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
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
