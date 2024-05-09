//
//  MovieDetailViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
import AVFoundation

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var trailerVideoView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movieId: Int?
    var viewModel: MovieDetailViewModel?
    
    private var categoryTabBarController = CategoryTabBarController()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
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
            handleMissingMovieId()
            return
        }
        print("MovieId: \(movieId)")
        viewModel?.fetchMovieDetails(movieId: movieId) { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if success {
                    if let movieDetails = strongSelf.viewModel?.movieDetails {
                        strongSelf.didFetchMovieDetails(details: movieDetails)
                    }
                } else {
                    strongSelf.handleFetchError()
                }
            }
        }
        configureEpisodesViewController()
    }
    
    private func handleMissingMovieId() {
        print("k có Id ")
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
            print("Title: \(details.title)")
            for video in details.videos.results {
                print("Video: \(video.name), Key: \(video.key)")
            }
            self?.titleLabel.text = details.title
            self?.overviewLabel.text = details.tagline
            if let trailerKey = details.videos.results.first?.key {
                self?.playVideo(with: trailerKey)
            }
        }
    }
    
    func fetchMovieDetailsDidFail(error: Error) {
        print("Failed to fetch movie details: \(error)")
        handleFetchError()
    }
    
    private func playVideo(with trailerKey: String) {
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(trailerKey)") else {
            print("Invalid video URL")
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = trailerVideoView.bounds
        trailerVideoView.layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    private func handleFetchError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Failed to fetch movie details. Please try again later.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
