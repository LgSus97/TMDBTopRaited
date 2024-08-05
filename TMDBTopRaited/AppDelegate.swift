//
//  AppDelegate.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


  let appDIContainer = AppDIContainer()
  var appFlowCoordinator: AppFlowCoordinator?
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //Override point for customization after application launch.
    
    AppAppearance.setupAppearance()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController = UINavigationController()

    window?.rootViewController = navigationController
    appFlowCoordinator = AppFlowCoordinator(
        navigationController: navigationController,
        appDIContainer: appDIContainer
    )
    appFlowCoordinator?.start()
    window?.makeKeyAndVisible()
    
    // Code to print font names
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
    
    return true    
  }



}


