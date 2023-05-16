//
//  ViewController.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: - Properties
    /// Search reasult data list
    var movieList: [MoviesInfoModel] = []
    
    // MARK: - Lazy load properties
    /// View to show details of a Search bar and result list
    lazy var searchView: MovieSerchView = {
        let view = MovieSerchView(frame: CGRect.zero)
        { searchText in
            // Request data when user click search
            self.requestMovieList(keyWord: searchText)
        } clickMovieCallback: { movieDetail in
            // Jump to details page when user click on a specific movie
            self.jumpToDetailPage(movieDetails: movieDetail)
        } loadNextpageCallback: { nextPage, searchText in
            self.requestNextPage(nextPage: nextPage, keyWord: searchText)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.view.backgroundColor = UIColor.white
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        
        addRigthButton()
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        // Add subviews
        view.addSubview(searchView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: - Click Actions
    /*
     Request to get movie list and update to view
     */
    func requestMovieList(keyWord: String) {
        // Show loading view while request
        AlertManager.shared.showLoading()
        MovieListRequest.requestMovieList(query: keyWord,
                                          networkManager: MovieNetworkManager.shared)
        { responseModel, error in
            // Hide loading view while get result
            AlertManager.shared.hideLoading()
            if let model = responseModel as? MoviesListModel {
                if model.totalResults == 0 {
                    // No result
                    AlertManager.showToast(message: Constants.Errors.Msg.emptyResponse)
                }
                // Show toast if there's an error when success
                if let err = error {
                    AlertManager.showToast(message: err.domain)
                }
                self.searchView.updateData(datalist: model, isNextPage: false)
            } else {
                AlertManager.showToast(message: Constants.Errors.Msg.emptyResponse)
            }
        } failure: { responseModel, error in
            // Hide loading view while get result
            AlertManager.shared.hideLoading()
            AlertManager.showToast(message: error?.domain ?? Constants.Errors.Msg.unknowError)
        }
    }
    
    /*
     Jump to related detail page of a movie
     */
    func jumpToDetailPage(movieDetails: MoviesInfoModel) {
        let detailVC = MovieDetailViewController(movieDetail: movieDetails)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /*
     Request to get movie list of next page and update to view
     */
    func requestNextPage(nextPage: Int, keyWord: String) {
        // Show loading view while request
        AlertManager.shared.showLoading()
        
        MovieListRequest.requestMovieList(query: keyWord,
                                          page: nextPage,
                                          networkManager: MovieNetworkManager.shared)
        { responseModel, error in
            if let model = responseModel as? MoviesListModel {
                // Hide loading view while get result
                AlertManager.shared.hideLoading()
                // Show toast if there's an error when success
                if let err = error {
                    AlertManager.showToast(message: err.domain)
                }
                // Update search view
                self.searchView.updateData(datalist: model, isNextPage: true)
            } else {
                AlertManager.showToast(message: Constants.Errors.Msg.emptyResponse)
            }
        } failure: { responseModel, error in
            // Hide loading view while get result
            AlertManager.shared.hideLoading()
            AlertManager.showToast(message: error?.domain ?? Constants.Errors.Msg.unknowError)
        }
    }
    
    /*
     Jump to favorite movie list view
     */
    @objc func jumpToFavoriteList() {
        let favoriteVC = FavoriteListViewController()
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    // MARK: - NavigationBar
    /*
     Add right button to navigation bar for jumping to favorite list view
     */
    func addRigthButton() {
        let jumptoFavoriteButton = UIBarButtonItem(title: Constants.Strings.FavoriteButton.jumpToFavoriteList,
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(jumpToFavoriteList))
        navigationItem.rightBarButtonItem = jumptoFavoriteButton
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}

