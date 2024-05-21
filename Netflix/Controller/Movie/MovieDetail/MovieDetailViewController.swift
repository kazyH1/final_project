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

class MovieDetailViewController: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var addMyListButton: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var videos: [Video]?
    var movie: Movie?
    var moviesMyList: [Movie]?
    var viewModel: MovieDetailViewModel?
    private let backButton = UIButton(type: .system)
    
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureEpisodesViewController()
        
        playerView.delegate = self
        
        //show button add to my list
        self.addMyListButton.isHidden = false
        
        //show back button
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, view.safeAreaInsets.top))
        initialSetup()
        
        guard let movieId = movie?.id else {

            return
        }
        
        viewModel?.fetchMovieDetails(movieId: movieId) { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.showSpinner(onView: strongSelf.view)
                if success {
                    if let movieDetails = strongSelf.viewModel?.movieDetails {
                        strongSelf.didFetchMovieDetails(details: movieDetails)
                        SwiftEventBus.post("updateCategoryTab", sender: movieDetails)
                    }
                } else {
                    strongSelf.handleFetchError()
                }
                strongSelf.removeSpinner()
            }
        }
        
        moviesMyList = Movie.getMyListMovie() ?? []
        self.addMyListButton.isHidden = checkMovieExistMyList(movie: self.movie!)
    }
    
    private func initialSetup() {
        
        // basic setup
        view.backgroundColor = .black
        
        // button customization
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        backButton.titleLabel?.textColor = .white
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func configureEpisodesViewController() {
        detailView.addSubview(categoryTabBarController.view)
        categoryTabBarController.view.frame = detailView.bounds
        addChild(categoryTabBarController)
        categoryTabBarController.didMove(toParent: self)
    }
    
    @IBAction func addToMyList(_ sender: Any) {
        var message = ""
        var title = ""
        var action = "OK"
        if(!checkMovieExistMyList(movie: self.movie!)){
            moviesMyList?.append(self.movie!)
            Movie.saveMyListMovie(movies: moviesMyList ?? [])
            message = "Added this movie to My List successful."
            title = "Success"
            action = "OK"
            //event to update MyList screen
            self.addMyListButton.isHidden = true
            SwiftEventBus.post("AddToMyList")
        } else {
            message = "This movie was added to My List."
            title = "Movie Exist"
            action = "Hide"
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        guard let videos = videos else {
            return
        }
        guard let clipKey = videos.first(where: { $0.type == "Clip" })?.key else {
            return
        }
        //navigation to watching screen
        let watchingMovieVC = WatchingMovieViewController()
        watchingMovieVC.movie = Movie(id: viewModel?.movieDetails?.id, key: clipKey, media_type: nil, original_name: nil, original_title: viewModel?.movieDetails?.title, poster_path: nil, backdrop_path: nil, overview: nil, vote_count: 0, release_date: nil, vote_average: 100)
        navigationController?.pushViewController(watchingMovieVC, animated: true)
    }
    
    
    func playVideo(with trailerKey: String) {
        playerView.load(withVideoId: trailerKey, playerVars: ["playsinline" : 1, "showinfo" : 0, "rel" : 0, "controls" : 0, "fs": 0, "autoplay": 1, "autohide": 1, "modestbranding": 1])
        playerViewDidBecomeReady(self.playerView)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
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
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                self.onBack()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkMovieExistMyList(movie: Movie) -> Bool{
        if moviesMyList!.contains(where: {$0.id == movie.id}) {
            return true
        } else {
            return false
        }
    }
}

