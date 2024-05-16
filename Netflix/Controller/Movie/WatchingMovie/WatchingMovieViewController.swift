//
//  WatchingMovieViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import AVKit
import UIKit

class WatchingMovieViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var viewControll: UIView!
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    
    @IBOutlet weak var seekSlider: UISlider! {
        didSet {
            self.seekSlider.addTarget(self, action: #selector(onTapToSlide), for: .valueChanged)
        }
    }
    
    
    @IBOutlet weak var imgFullScreenToggle: UIImageView! {
        didSet {
            self.imgFullScreenToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapToggleScreen)))
        }
    }
    
    @IBOutlet weak var img10SecBack: UIImageView! {
        didSet {
            self.img10SecBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecBack)))
        }
    }
    @IBOutlet weak var imgPlay: UIImageView! {
        didSet {
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlayPause)))
        }
    }
    @IBOutlet weak var img10SecFor: UIImageView! {
        didSet {
            self.img10SecFor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecNext)))
        }
    }
    
    let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    var movie: Movie?
    var viewModel: WatchingMovieViewModel?
    private var player : AVPlayer? = nil
    private var playerLayer : AVPlayerLayer? = nil
    
    private var categoryTabBarController = CategoryTabBarController()
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = WatchingMovieViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = TabBarViewController()
        tabbar.tabBar.isHidden = true
        
        DeviceOrientation.shared.set(orientation: .landscapeRight)
        
        //show back button
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, view.safeAreaInsets.top))
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setVideoPlayer()
    }
    
    
    @IBAction func back(_ sender: Any) {
        DeviceOrientation.shared.set(orientation: .portrait)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setVideoPlayer() {
        guard let url = URL(string: videoURL) else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.playerLayer?.frame = self.videoPlayer.bounds
            self.playerLayer?.addSublayer(self.viewControll.layer)
            if let playerLayer = self.playerLayer {
                self.view.layer.addSublayer(playerLayer)
            }
            self.player?.play()
        }
        self.setObserverToPlayer()
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.playerLayer?.frame = self.videoPlayer.bounds
        })
    }
    
    
    private var timeObserver : Any? = nil
    private func setObserverToPlayer() {
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    
    private func updatePlayerTime() {
        guard let currentTime = self.player?.currentTime() else { return }
        guard let duration = self.player?.currentItem?.duration else { return }
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isThumbSeek == false {
            self.seekSlider.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
        
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        
        var hours = value / 3600
        var mins =  (value / 60).truncatingRemainder(dividingBy: 60)
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbCurrentTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
        
        hours = durationTimeInSecond / 3600
        mins = (durationTimeInSecond / 60).truncatingRemainder(dividingBy: 60)
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbTotalTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
    }
    
    
    @objc private func onTap10SecNext() {
        guard let currentTime = self.player?.currentTime() else { return }
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        self.player?.seek(to: seekTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTap10SecBack() {
        guard let currentTime = self.player?.currentTime() else { return }
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        self.player?.seek(to: seekTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTapPlayPause() {
        if self.player?.timeControlStatus == .playing {
            self.imgPlay.image = UIImage(systemName: "pause.circle")
            self.player?.pause()
        } else {
            self.imgPlay.image = UIImage(systemName: "play.circle")
            self.player?.play()
        }
    }
    
    private var isThumbSeek : Bool = false
    @objc private func onTapToSlide() {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
    
    @objc private func onTapToggleScreen() {
        if #available(iOS 16.0, *) {
            guard let windowSceen = self.view.window?.windowScene else { return }
            if windowSceen.interfaceOrientation == .portrait {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    print(error.localizedDescription)
                }
            } else {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    print(error.localizedDescription)
                }
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            } else {
                let orientation = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            }
        }
    }
}

