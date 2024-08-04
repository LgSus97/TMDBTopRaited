//
//  TopRaitedViewController.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 03/08/24.
//

import UIKit

final class TopRaitedViewController: UIViewController {
  
  private var viewModel: MoviesListViewModel!
  private var posterImagesRepository: PosterImagesRepository?

  
  static func create(
      with viewModel: MoviesListViewModel,
      posterImagesRepository: PosterImagesRepository?
  ) -> TopRaitedViewController {
      let view = TopRaitedViewController()
      view.viewModel = viewModel
      view.posterImagesRepository = posterImagesRepository
      return view
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel.didSearch(query: "Toy")
      viewModel.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
