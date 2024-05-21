//
//  EpisodesViewController.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit
import SDWebImage
import SwiftEventBus

class TrailersMoreViewController: UIViewController {

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
            self.videoFilters = movieDetails.videos.results.filter{ $0.type == "Trailer" }
            self.update(videos: self.videoFilters)
             }
    }
    
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
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
    }
}

extension TrailersMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        //let movieDetailVC = MovieDetailViewController()
        //movieDetailVC.playVideo(with: "ZRCF8GP25sw")
        //navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    
}

