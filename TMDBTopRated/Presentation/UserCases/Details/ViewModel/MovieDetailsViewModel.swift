//
//  MovieDetailsViewModel.swift
//  ExampleMVVM
//


import Foundation

protocol MovieDetailsViewModelInput {
  func updatePosterImage(width: Int)
}

protocol MovieDetailsViewModelOutput {
  var title: String { get }
  var posterImage: Observable<Data?> { get }
  var isPosterImageHidden: Bool { get }
  var overview: String { get }
  var releaseDate: String { get}
  var voteAverage: String { get}
}

protocol MovieDetailsViewModel: MovieDetailsViewModelInput, MovieDetailsViewModelOutput { }

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
  
  private let posterImagePath: String?
  private let posterImagesRepository: PosterImagesRepository
  private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
  
  // MARK: - OUTPUT
  let title: String
  let posterImage: Observable<Data?> = Observable(nil)
  let isPosterImageHidden: Bool
  let overview: String
  let releaseDate: String
  let voteAverage: String
  
  
  init(movie: Movie,
       posterImagesRepository: PosterImagesRepository) {
    //self.title = "\(NSLocalizedString("Title", comment: "")): \(movie.title ?? "")"
    self.title = movie.title ?? ""
    self.overview = movie.overview ?? ""
    if let releaseDate = movie.releaseDate {
      self.releaseDate = "\(NSLocalizedString("Release Date", comment: "")): \(dateFormatter.string(from: releaseDate))"
    } else {
      self.releaseDate = NSLocalizedString("To be announced", comment: "")
    }
    
    self.voteAverage = "\(NSLocalizedString("Raiting", comment: "")): \(movie.voteAverage)"
    self.posterImagePath = movie.backdropPath
    self.isPosterImageHidden = movie.posterPath == nil
    self.posterImagesRepository = posterImagesRepository
  }
}

// MARK: - INPUT. View event methods
extension DefaultMovieDetailsViewModel {
  
  func updatePosterImage(width: Int) {
    guard let posterImagePath = posterImagePath else { return }
    
    imageLoadTask = posterImagesRepository.fetchImage(with: posterImagePath, width: width) { result in
      guard self.posterImagePath == posterImagePath else { return }
      switch result {
      case .success(let data):
        self.posterImage.value = data
      case .failure: break
      }
      self.imageLoadTask = nil
    }
  }
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()
