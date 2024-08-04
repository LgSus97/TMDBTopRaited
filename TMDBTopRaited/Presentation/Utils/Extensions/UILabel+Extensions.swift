//
//  UILabel+Extension.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

extension UILabel {
  func setMontserratFont(style: MontserratFont, size: CGFloat, color: UIColor) {
    self.font = UIFont.montserratFont(style, size: size)
    self.textColor = color
  }
}
