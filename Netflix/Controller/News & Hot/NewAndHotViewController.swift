//
//  NewAndHotViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

final class NewAndHotViewController: BaseViewController {
    @IBOutlet weak var upComingTableView: UITableView!
    
    private var movies: [Movie] = [Movie]()
    private var viewModel: NewAndHotViewModel?

    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = NewAndHotViewModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New & Hot"
        configureNavbar()
        fetchMyList()
        registerTableView()
    }
    
    
    private func registerTableView() {
        upComingTableView.dataSource = self
        upComingTableView.delegate = self
        upComingTableView.separatorColor = UIColor("#737373")
        upComingTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    private func fetchMyList() {
        self.showSpinner(onView: self.view)
        viewModel?.fetchUpComingMovies() { result in
            switch result {
            case .success(let movie):
                self.removeSpinner()
                self.movies = movie
                DispatchQueue.main.async {
                    self.upComingTableView.reloadData()
                }
            case .failure(let error):
                self.removeSpinner()
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension NewAndHotViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.upComingTableView.setEmptyMessage("New & Hot list is empty data!", movies.isEmpty)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upComingTableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return .init() }
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
