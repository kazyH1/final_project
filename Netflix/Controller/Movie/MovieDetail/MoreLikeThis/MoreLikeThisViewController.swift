//
//  EpisodesViewController.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit
import SDWebImage
import SwiftEventBus

class MoreLikeThisViewController: UIViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    
    var videoFilters: [Video] = [Video]()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SwiftEventBus.unregister(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
        
        SwiftEventBus.onMainThread(self, name: "updateCategoryTab") { result in
            let movieDetails : MovieDetailResponse = result?.object as! MovieDetailResponse
            self.videoFilters = movieDetails.videos.results.filter{ $0.type == "Featurette" }
            self.update(videos: self.videoFilters)
             }
    }
    // dùng delegate, 
    
    func update(videos: [Video]?){
        DispatchQueue.main.async {
            self.videoFilters = videos ?? []
            self.episodesTableView?.reloadData()
            self.episodesTableView?.beginUpdates()
            self.episodesTableView?.endUpdates()
        }
    }
    
    private func registerTableView() {
        episodesTableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodesTableViewCell")
        episodesTableView.backgroundColor = .black
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.separatorColor = UIColor("#737373")
    }
}

extension MoreLikeThisViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.episodesTableView.setEmptyMessageTop("The list is empty data!", videoFilters.isEmpty)
        return videoFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = episodesTableView.dequeueReusableCell(withIdentifier: "EpisodesTableViewCell", for: indexPath) as? EpisodesTableViewCell else { return .init() }
        cell.configure(with: videoFilters[indexPath.row])
        cell.backgroundColor = .black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor("#000000", alpha: 0.5)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let video = videoFilters[indexPath.row]
        let posterPath = "https://img.youtube.com/vi/\(video.key)/0.jpg"
        let watchingMovieVC = WatchingMovieViewController()
        watchingMovieVC.movie = Movie(id: nil, key: video.key, media_type: nil, original_name: nil, original_title: video.name, poster_path: posterPath, backdrop_path: nil, overview: nil, vote_count: 0, release_date: nil, vote_average: 100)
        navigationController?.pushViewController(watchingMovieVC, animated: true)
    }
    
    
}

