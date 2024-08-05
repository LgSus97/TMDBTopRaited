//
//  Appearence.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import UIKit

final class AppAppearance {
  
  static func setupAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [.foregroundColor: STColors.snowWhite]
    appearance.backgroundColor = STColors.oceanDeep
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
}

extension UINavigationController {
  @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
