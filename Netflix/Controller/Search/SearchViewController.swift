//
//  SearchViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    private var movies: [Movie] = [Movie]()
    private var viewModel: SearchViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = SearchViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV Show"
        controller.searchBar.searchBarStyle = .default
        controller.searchBar.searchTextField.backgroundColor = .white
        controller.searchBar.searchTextField.textColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        controller.searchBar.barTintColor = UIColor.black
        controller.searchBar.tintColor = UIColor.black
        UIBarButtonItem.appearance().tintColor = UIColor.white
        return controller
    }()
    
    override func willMove(toParent parent: UIViewController?) {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        
        configureNavigation()
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
        
        fetchSearch()
    }
    
    private func registerTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
    }
}

extension SearchViewController {
    func configureNavigation() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Search"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .black
        navBarAppearance.shadowColor = nil
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchSearch() {
        self.showSpinner(onView: self.view)
        viewModel?.fetchSearchMovies() { result in
            switch result {
            case .success(let movie):
                self.removeSpinner()
                self.movies = movie
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                self.removeSpinner()
                print(error.localizedDescription)
            }
            
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchTableView.setEmptyMessage("The list is empty data!", movies.isEmpty)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return .init() }
        cell.configure(with: TitleView(titleName: (movies[indexPath.row].original_title ?? movies[indexPath.row].original_name) ?? "Unknown", posterURL: movies[indexPath.row].poster_path ?? ""))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //navigate to Detail
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = movies[indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidItemTap(movie: Movie) {
        //navigate to Detail
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = movie
        movieDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        resultsController.delegate = self
        resultsController.searchResultsCollectionView.backgroundColor = .black
        
        viewModel?.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    resultsController.movies = movie
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
