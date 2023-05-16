//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit

class MovieDetailViewController: UIViewController, UINavigationBarDelegate {
    // MARK: - Properties
    /// Movie detail data
    var movieDetailModel: MoviesInfoModel
    
    // MARK: - Lazy load properties
    /// The button to add/remove current movie to/from favorite list
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// View to show details of a movie
    lazy var detailView: MovieDetailView = {
        let view = MovieDetailView.init(frame: CGRect.zero, dataModel: movieDetailModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    init(movieDetail: MoviesInfoModel) {
        self.movieDetailModel = movieDetail
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        addFavoriteButton()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        // Add subviews
        view.addSubview(detailView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Favorite
    /*
     Add button to navigation bar to allow user to add the current movie to favorite list, or remove it from favorite list
     */
    func addFavoriteButton() {
        self.favoriteButton.tag = self.checkIsFavorite() ? 1 : -1
        self.favoriteButton.setTitle(self.favoriteButton.tag == 1 ? Constants.Strings.FavoriteButton.remove : Constants.Strings.FavoriteButton.add, for: .normal)
        self.favoriteButton.sizeToFit()

        // Create UIBarButtonItem
        let customBarItem = UIBarButtonItem(customView: self.favoriteButton)

        // Add to navigation bar
        navigationItem.rightBarButtonItems = [customBarItem]
    }
    
    @objc func favoriteButtonTapped() {
        self.favoriteButton.tag = self.favoriteButton.tag * -1
        self.favoriteButton.setTitle(self.favoriteButton.tag == 1 ? Constants.Strings.FavoriteButton.remove : Constants.Strings.FavoriteButton.add, for: .normal)
        self.favoriteButton.sizeToFit()
        // Change status in Database
        if let id = self.movieDetailModel.id {
            CoreDataManager.shared.changeFavoriteStatus(id: id)
        }
    }
    
    /*
     Check if the current movie is favorite
     */
    func checkIsFavorite() -> Bool {
        if let id = self.movieDetailModel.id {
            return CoreDataManager.shared.checkIsFavorite(id: id)
        } else {
            return false
        }
    }
}
