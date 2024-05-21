//
//  WatchingMovieViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
import youtube_ios_player_helper

class WatchingMovieViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    
    
    
    var movie: Movie?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DeviceOrientation.shared.set(orientation: .portrait)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // basic setup
        //view.backgroundColor = .black
        //show back button
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, view.safeAreaInsets.top))
        
        self.navigationItem.searchController = nil
    
        DeviceOrientation.shared.set(orientation: .landscapeRight)
        
        playerView.delegate = self
        
        playVideo(with: movie?.key ?? "")
    }
    
    @IBAction func onBackScreen(_ sender: Any) {
        onBack()
    }
    
    func onBack(){
        DeviceOrientation.shared.set(orientation: .portrait)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func playVideo(with trailerKey: String) {
        playerView.load(withVideoId: trailerKey, playerVars: ["playsinline" : 0, "showinfo" : 0, "rel" : 0, "controls" : 0, "fs": 0, "autoplay": 1, "autohide": 1, "modestbranding": 1])
        playerViewDidBecomeReady(self.playerView)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

}

