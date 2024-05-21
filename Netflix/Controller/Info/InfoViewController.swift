//
//  InfoViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 10/05/2024.
//

import UIKit
import SnapKit
class InfoViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
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
            DispatchQueue.main.async {
                strongSelf.showSpinner(onView: strongSelf.view)
                if success {
                    if (strongSelf.viewModel?.movieDetails) != nil {
                        strongSelf.collectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "Failed to fetch movie details. Please try again later.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                            strongSelf.backAction()
                        }))
                        strongSelf.present(alertController, animated: true, completion: nil)
                    }
                }
                strongSelf.removeSpinner()
            }
        }
    }
    
    
    private func setupLayout() {
        self.view.backgroundColor = .black
        self.createCollectionView()
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.register(DetailSeriesCastCollectionCell.self, self.collectionView)
        self.collectionView.register(DetailVideoCollectionCell.self, self.collectionView)
        self.collectionView.register(DetailCommentCollectionCell.self, self.collectionView)
        self.collectionView.register(DetailRecomendCollectionCell.self, self.collectionView)
        self.collectionView.registerHeader(DetailHeaderSection.self, self.collectionView)
        self.collectionView.registerHeader(DetailHeaderTitle.self, self.collectionView)
        self.collectionView.backgroundColor = .black
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
//        if indexPath.section == DetailSection.comment {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailCommentCollectionCell.self), for: indexPath) as? DetailCommentCollectionCell else {
//                fatalError()
//            }
//            cell.backgroundColor = .black
//            return cell
//        }
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
//            else if indexPath.section == DetailSection.comment {
//                headerView.title.text = str_detail_section_comment
//                headerView.btnMore.isHidden = false
//            }
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

extension InfoViewController : DetailHeaderSectionDelegate {
    func didPressReadMore(sender: DetailHeaderSection, height: CGFloat) {
        self.heightLabelReadMore = height
        self.collectionView.performBatchUpdates({
            self.collectionView.reloadData()
        }, completion: nil)
    }
}
