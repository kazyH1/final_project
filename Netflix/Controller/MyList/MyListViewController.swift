//
//  MyListViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 10/05/2024.
//

import UIKit
import SwiftEventBus

class MyListViewController: UIViewController {
    
    @IBOutlet weak var myListTableView: UITableView!
    
    var moviesMyList: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        navigationItem.title = "My List"
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        registerTableView()
        
        fetchMovieInList()
        //when receive this name, fetch MyList and update UI
        SwiftEventBus.onMainThread(self, name: "AddToMyList") { result in self.fetchMovieInList()}
        
        
        
    }
    
    private func registerTableView() {
        myListTableView.dataSource = self
        myListTableView.delegate = self
        myListTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .black
        navBarAppearance.shadowColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchMovieInList() {
        self.showSpinner(onView: self.view)
        self.moviesMyList = Movie.getMyListMovie() ?? []
        DispatchQueue.main.async {
            self.myListTableView.reloadData()
            self.removeSpinner()
        }
        
    }
    
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesMyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myListTableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.configure(with: TitleView(titleName: (moviesMyList?[indexPath.row].original_title ?? moviesMyList?[indexPath.row].original_name) ?? "Unknown", posterURL: moviesMyList?[indexPath.row].poster_path ?? ""))
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = moviesMyList?[indexPath.row]
        movieDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}


