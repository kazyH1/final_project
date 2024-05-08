//
//  EpisodesViewController.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodesTableViewCell")
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = episodesTableView.dequeueReusableCell(withIdentifier: "EpisodesTableViewCell", for: indexPath) as? EpisodesTableViewCell else { return .init() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    
}
