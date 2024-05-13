//
//  ViewController.swift
//  Netflix
//
//  Created by Admin on 11/04/2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: BaseViewController {
    
    
    @IBOutlet private weak var homeFeedTableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: HomeViewModel?
    private var headerView: HeaderView?
    private var randomTrendingMovie: Movie?
    private let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = HomeViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureNavbar()
        setupTableHeaderView()
        // Configure header view
        getMovieForTableHeaderView()
    }
    
}

// MARK: - setupUI
extension HomeViewController {
    
    private func setupTableView() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeFeedTableView.register(UINib(nibName: "HeaderInSectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderInSectionView")
    }
    
    private func setupTableHeaderView() {
        let heightOfHeaderView = view.bounds.height * 3 / 5
        let widthOfHeaderView = view.bounds.width
        let headerHeight = traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular ? heightOfHeaderView + 400 : heightOfHeaderView
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: widthOfHeaderView, height: headerHeight))
        homeFeedTableView.tableHeaderView = headerView
        self.headerView = headerView
        self.headerView?.delegate = self
    }
}

//MARK: Configuration Methods
extension HomeViewController {
    
    private func configureCell(for cell: HomeTableViewCell, at section: Int) {
        let category: String
        switch section {
        case Category.TrendingMovies.rawValue:
            category = "trending/movie/day"
        case Category.TrendingTv.rawValue:
            category = "trending/tv/day"
        case Category.Popular.rawValue:
            category = "movie/popular"
        case Category.Upcoming.rawValue:
            category = "movie/upcoming"
        case Category.TopRated.rawValue:
            category = "movie/top_rated"
        default:
            return
        }
        viewModel?.getMovies(for: category) { result in
            self.handleResult(result, for: cell)
        }
    }
    
    private func handleResult(_ result: Result<[Movie], Error>, for cell: HomeTableViewCell) {
        switch result {
        case .success(let movies):
            cell.configure(with: movies)
        case .failure(let error):
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
    }
    
    private func getMovieForTableHeaderView() {
        viewModel?.fetchTrendingMoviePosterPath { [weak self] result in
            switch result {
            case .success(let movies):
                if let randomMovie = movies.first {
                    self?.headerView?.configure(with: randomMovie.poster_path, id: randomMovie.id ?? 0)
                }
            case .failure(let error):
                print("Failed to configure header view: \(error.localizedDescription)")
            }
        }
    }
}


//MARK: TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderInSectionView") as? HeaderInSectionView else {return .init()}
        headerView.sectionTitle.text = sectionTitles[section].capitalizeFirstLetter()
        return headerView
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return .init() }
        cell.registerCollecTionView()
        configureCell(for: cell, at: indexPath.section)
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: HomeTableViewCellDelegate, HomeHeaderViewDelegate {
    func didTapPlayButton(at id: Int) {
        let movieDetailVC = MovieDetailViewController()
            movieDetailVC.movieId = id
            navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func didTapMyListButton() {
        let movieDetailVC = MyListViewController()
            navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func didTapInfoButton() {
        let movieDetailVC = InfoViewController()
            navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func didSelectMovie(at id: Int) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieId = id
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

