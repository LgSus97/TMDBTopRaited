//
//  UIFont+Extensions.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 04/08/24.
//

import UIKit

enum MontserratFont: String {
  case regular = "Montserrat-Regular"
  case semibold = "Montserrat-SemiBold"
  case thin = "Montserrat-Thin"
  case medium = "Montserrat-Medium"
  case bold = "Montserrat-Bold"
}

extension UIFont {
  static func montserratFont(_ style: MontserratFont, size: CGFloat) -> UIFont? {
    return UIFont(name: style.rawValue, size: size)
  }
}
