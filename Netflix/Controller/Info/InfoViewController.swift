//
//  InfoViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 10/05/2024.
//

import UIKit

final class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    
    private var movies: [Movie] = [Movie]()
    private var viewModel: InfoViewModel?

    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = InfoViewModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All Trending Info"
        navigationController?.navigationBar.prefersLargeTitles = false
      
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        fetchMovies()
        registerTableView()
    }
    
    private func registerTableView() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    private func fetchMovies() {
        viewModel?.fetchMyListMovies() { result in
            switch result {
            case .success(let movie):
                self.movies = movie
                DispatchQueue.main.async {
                    self.infoTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = infoTableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return .init() }
        cell.configure(with: TitleView(titleName: (movies[indexPath.row].original_title ?? movies[indexPath.row].original_name) ?? "Unknown", posterURL: movies[indexPath.row].poster_path ?? ""))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = movies[indexPath.row]
            navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
