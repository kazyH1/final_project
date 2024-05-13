//
//  MovieDetailViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper
import SwiftEventBus

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movieId: Int?
    var videos: [Video]?
    var viewModel: MovieDetailViewModel?
    
    private var categoryTabBarController = CategoryTabBarController()
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = MovieDetailViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        guard let movieId = movieId else {
            return
        }
        
        viewModel?.fetchMovieDetails(movieId: movieId) { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if success {
                    if let movieDetails = strongSelf.viewModel?.movieDetails {
                        strongSelf.didFetchMovieDetails(details: movieDetails)
                        SwiftEventBus.post("updateCategoryTab", sender: movieDetails)
                    }
                } else {
                    strongSelf.handleFetchError()
                }
            }
        }
        configureEpisodesViewController()
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        guard let videos = videos else {
                // Không có video được tải xuống
                return
            }
            guard let clipKey = videos.first(where: { $0.type == "Clip" })?.key else {
                // Không tìm thấy video loại Clip
                return
            }
            playVideo(with: clipKey)
    }
    
    private func configureEpisodesViewController() {
        detailView.addSubview(categoryTabBarController.view)
        categoryTabBarController.view.frame = detailView.bounds
        addChild(categoryTabBarController)
        categoryTabBarController.didMove(toParent: self)
    
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didFetchMovieDetails(details: MovieDetailResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = details.title
            self?.overviewLabel.text = details.overview
            self?.videos = details.videos.results
            if let trailerKey = details.videos.results.first?.key {
                self?.playVideo(with: trailerKey)
            }
        }
    }
    
    func fetchMovieDetailsDidFail(error: Error) {
        print("Failed to fetch movie details: \(error)")
        handleFetchError()
    }
    
    private func handleFetchError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Failed to fetch movie details. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
extension MovieDetailViewController: YTPlayerViewDelegate {
    func playVideo(with trailerKey: String) {
        playerView.load(withVideoId: trailerKey, playerVars: ["playsinline": 1])
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

