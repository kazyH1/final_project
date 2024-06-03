//
//  MyListViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 10/05/2024.
//

import UIKit
import SwiftEventBus

class MyListViewController: BaseViewController {
    
    @IBOutlet weak var myListTableView: UITableView!
    
    var moviesMyList: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavbar()
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
        myListTableView.separatorColor = UIColor("#737373")
        myListTableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
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
        self.myListTableView.setEmptyMessage("My List is empty data!", moviesMyList == nil || moviesMyList!.isEmpty)
        return moviesMyList?.count ?? 0
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            moviesMyList?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Movie.saveMyListMovie(movies: moviesMyList ?? [])
            SwiftEventBus.post("DeleteItemMyList")
            tableView.endUpdates()
        }
    }
}


