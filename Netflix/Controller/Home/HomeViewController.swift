//
//  ViewController.swift
//  Netflix
//
//  Created by Admin on 11/04/2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
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
        
        // Configure header view
        configureHeaderView()
        setupHeaderView()
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
    
    private func setupHeaderView() {
        let heightOfHeaderView = view.bounds.height * 3 / 5
        let widthOfHeaderView = view.bounds.width
        let headerHeight = traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular ? heightOfHeaderView + 400 : heightOfHeaderView
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: widthOfHeaderView, height: headerHeight))
        homeFeedTableView.tableHeaderView = headerView
        self.headerView = headerView
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "userIcon"), style: .done, target: self, action: #selector(handleLogout))
        navigationController?.navigationBar.tintColor = .white
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
    
    private func configureHeaderView() {
        viewModel?.fetchTrendingMoviePosterPath { [weak self] result in
            switch result {
            case .success(let posterPath):
                self?.headerView?.configure(with: posterPath)
            case .failure(let error):
                print("Failed to configure header view: \(error.localizedDescription)")
            }
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
}

//MARK: - Helper Methods
extension HomeViewController {
    @objc func showDetail(_ button:UIButton){
        let listVC = ListMovieViewController()
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func handleLogout() {
        viewModel?.logOut()
        let displayVC = DisplayViewController()
        let navigationController = UINavigationController(rootViewController: displayVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

//MARK: TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderInSectionView") as? HeaderInSectionView else {return .init()}
        headerView.sectionTitle.text = sectionTitles[section]
        headerView.sectionTitle.text = headerView.sectionTitle.text?.capitalizeFirstLetter()
        headerView.seeAllButton.addTarget(self, action: #selector(showDetail(_:)), for: .touchUpInside)
        headerView.seeAllButton.tag = section
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


