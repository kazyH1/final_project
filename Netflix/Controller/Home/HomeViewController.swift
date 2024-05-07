//
//  ViewController.swift
//  Netflix
//
//  Created by Admin on 11/04/2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    enum Sections: Int {
        case TrendingMovies = 0
        case TrendingTv = 1
        case Popular = 2
        case Upcoming = 3
        case TopRated = 4
    }
    
    private var headerView: HeaderView?
    private var randomTrendingMovie: Movie?
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    @IBOutlet weak var homeFeedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        configureNavbar()
        configureHeaderView()
        let heightOfHeaderView = view.bounds.height * 3 / 5
        let widthOfHeaderView = view.bounds.width
        let horizontalSizeClass = self.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.traitCollection.verticalSizeClass
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: widthOfHeaderView, height: heightOfHeaderView + 400))
            homeFeedTableView.tableHeaderView =  headerView
        } else {
            let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: widthOfHeaderView, height: heightOfHeaderView))
            homeFeedTableView.tableHeaderView =  headerView
        }
    }
    
    private func registerTableView() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        // Setup Title Label
        let title = UILabel()
        title.text = sectionTitles[section]
        title.textColor = UIColor.white
        title.text = title.text?.capitalizeFirstLetter()
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Button
        let seeAllButton = UIButton(type: .system)
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(UIColor.gray, for: .normal)
        seeAllButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        seeAllButton.addTarget(self, action: #selector(showDetail(_:)), for: .touchUpInside)
        seeAllButton.tag = section
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add Subviews
        view.addSubview(title)
        view.addSubview(seeAllButton)
        
        // Setup Constraints
        NSLayoutConstraint.activate([
            // Title Label Constraints
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.heightAnchor.constraint(equalToConstant: 30),
            
            // See All Button Constraints
            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            seeAllButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            seeAllButton.widthAnchor.constraint(equalToConstant: 62),
            seeAllButton.heightAnchor.constraint(equalToConstant: 12)
        ])
        return view
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
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            HomeViewModel.shared.getTrendingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTv.rawValue:
            HomeViewModel.shared.getTrendingTvs { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            HomeViewModel.shared.getPopular { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            HomeViewModel.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            HomeViewModel.shared.getTopRated { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
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

extension HomeViewController {
    private func configureHeaderView() {
        HomeViewModel.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                guard !movies.isEmpty else {
                    print("No trending movies available")
                    return
                }
                let randomIndex = Int.random(in: 0..<movies.count)
                let randomMovie = movies[randomIndex]
                guard let posterPath = randomMovie.poster_path else {
                    print("No poster available for the randomly selected movie")
                    return
                }
                    self?.headerView?.configure(with: posterPath)
            case .failure(let error):
                print("Failed to get trending movies: \(error.localizedDescription)")
            }
        }
    }

    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "userIcon"), style: .done, target: self, action: #selector(handleLogout))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func showDetail(_ button:UIButton){
        let listVC = ListMovieViewController()
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let signInViewModel = SignInViewModel.shared
            signInViewModel.clearUserLoggedInState()
            let displayVC = DisplayViewController()
            let navigationController = UINavigationController(rootViewController: displayVC)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        } catch {
            print("Đăng xuất không thành công: \(error.localizedDescription)")
        }
    }
}




