//
//  InfoViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 10/05/2024.
//

import UIKit
import SnapKit
class InfoViewController: BaseViewController {
    
    @IBOutlet weak var infoCollectionView: UICollectionView!
    var heightLabelReadMore : CGFloat = 120.0
    var movie: Movie?
    private var viewModel: InfoViewModel?
    
    init() {
        self.viewModel = InfoViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        getDetailMovie()
        configureNavbar()
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backAction)),
                                              UIBarButtonItem(image: UIImage(named: "netflixLogo"), style: .done, target: self, action: nil)
        ]
    }
    
    // MARK: API
    private func getDetailMovie() {
        guard (movie?.id) != nil else {
            return
        }
        
        viewModel?.fetchMovieDetails(movieId: movie?.id ?? 0) { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                strongSelf.showSpinner(onView: strongSelf.view)
                if success {
                    if (strongSelf.viewModel?.movieDetails) != nil {
                        strongSelf.infoCollectionView.reloadData()
                    }
                } else {
                    strongSelf.alertHandelError()
                }
                strongSelf.removeSpinner()
            }
        }
    }
    
    private func alertHandelError(){
        let alertController = UIAlertController(title: "Error", message: "Failed to fetch movie details. Please try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
            self.backAction()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    private func setupLayout() {
        self.view.backgroundColor = .black
        self.createCollectionView()
    }
    
    private func createCollectionView() {
        self.infoCollectionView.delegate = self
        self.infoCollectionView.dataSource = self
        self.infoCollectionView.contentInsetAdjustmentBehavior = .never
        self.infoCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.infoCollectionView.bounces = false
        self.infoCollectionView.alwaysBounceVertical = false
        self.infoCollectionView.register(DetailSeriesCastCollectionCell.self, self.infoCollectionView)
        self.infoCollectionView.register(DetailVideoCollectionCell.self, self.infoCollectionView)
        self.infoCollectionView.register(DetailCommentCollectionCell.self, self.infoCollectionView)
        self.infoCollectionView.register(DetailRecomendCollectionCell.self, self.infoCollectionView)
        self.infoCollectionView.registerHeader(DetailHeaderSection.self, self.infoCollectionView)
        self.infoCollectionView.registerHeader(DetailHeaderTitle.self, self.infoCollectionView)
        self.infoCollectionView.backgroundColor = .black
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == DetailSection.info {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == DetailSection.series {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailSeriesCastCollectionCell.self), for: indexPath) as? DetailSeriesCastCollectionCell else {
                fatalError()
            }
            cell.backgroundColor = .black
            cell.arrCasts = self.viewModel?.movieDetails?.movieCast ?? []
            return cell
        }
        if indexPath.section == DetailSection.video {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailVideoCollectionCell.self), for: indexPath) as? DetailVideoCollectionCell else {
                fatalError()
            }
            cell.arrVideos = self.viewModel?.movieDetails?.videos.results ?? []
            cell.backgroundColor = .black
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailRecomendCollectionCell.self), for: indexPath) as? DetailRecomendCollectionCell else {
            fatalError()
        }
        cell.backgroundColor = .black
        cell.arr = self.viewModel?.movieDetails?.recommendations?.results ?? []
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == DetailSection.info {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: DetailHeaderSection.self), for: indexPath) as? DetailHeaderSection else {
                    fatalError("Invalid view type")
                }
                headerView.backgroundColor = .black
                headerView.configure(movieDetail: self.viewModel?.movieDetails)
                headerView.addGenre(arr: self.viewModel?.movieDetails?.genres ?? [])
                headerView.delegate = self
                return headerView
            }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: DetailHeaderTitle.self), for: indexPath) as? DetailHeaderTitle else {
                fatalError("Invalid view type")
            }
            headerView.btnMore.isHidden = true
            headerView.backgroundColor = UIColor("#292929")
            headerView.title.textColor = .white
            if indexPath.section == DetailSection.series {
                headerView.title.text = str_detail_section_series
            }
            else if indexPath.section == DetailSection.video {
                headerView.title.text = str_detail_section_video
            }
            else if indexPath.section == DetailSection.recommend {
                headerView.title.text = str_detail_section_recomend
                headerView.moreButton = {
                    print("see full recommendation list")
                }
                headerView.btnMore.isHidden = false
            }
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
}

extension InfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == DetailSection.series {
            return CGSize(width: fullWidth, height: 178)
        }
        if indexPath.section == DetailSection.video {
            return CGSize(width: fullWidth, height: 165)
        }
        //        if indexPath.section == DetailSection.comment {
        //            return CGSize(width: fullWidth, height: 145*3)
        //        }
        if indexPath.section == DetailSection.recommend {
            return CGSize(width: fullWidth, height: 250)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == DetailSection.info {
            return CGSize(width: fullWidth, height: 310 + heightLabelReadMore + 170)
        }
        return CGSize(width: fullWidth, height: 48)
        
    }
}

extension InfoViewController : DetailHeaderSectionDelegate, DetailVideoCellDelegate {
    func didSelectMovie(video: Video, posterPath: String) {
        let watchingMovieVC = WatchingMovieViewController()
        watchingMovieVC.movie = Movie(id: nil, key: video.key, media_type: nil, original_name: nil, original_title: video.name, poster_path: posterPath, backdrop_path: nil, overview: nil, vote_count: 0, release_date: nil, vote_average: 100)
        navigationController?.pushViewController(watchingMovieVC, animated: true)
    }
    
    func didPressReadMore(sender: DetailHeaderSection, height: CGFloat) {
        self.heightLabelReadMore = height
        self.infoCollectionView.performBatchUpdates({
            self.infoCollectionView.reloadData()
        }, completion: nil)
    }
    
}
