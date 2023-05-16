//
//  FavoriteListViewController.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/14.
//


import UIKit

class FavoriteListViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    /// Search reasult data list
    var movieList: [MoviesInfoModel] = []
    
    // MARK: - Lazy load properties
    /// Table view to show the favorite movies list
    lazy var resultTableView: UITableView = {
        let resultTableView = UITableView()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.translatesAutoresizingMaskIntoConstraints = false
        return resultTableView
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
        requestFavoriteList()
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        self.view.addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

    }
    
    // MARK: - Click Actions
    /*
     Request to get favorite movie list
     */
    func requestFavoriteList() {
        self.movieList = CoreDataManager.shared.getFavoriteMovieList()
        self.resultTableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    // Set same height for each cell
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Jump to detail page when click
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // remove the selected status of current row
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Jump to detail page
        let detailVC = MovieDetailViewController(movieDetail: movieList[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create current cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell") as? MoviesTableViewCell {
            // If already have reuseable cell, then update data only
            cell.updateData(dataModel: movieList[indexPath.row])
            return cell
        } else {
            // If haven't reuseable cell, then create with data
            return MoviesTableViewCell(style: .default, reuseIdentifier: "MoviesTableViewCell", dataModel: movieList[indexPath.row])
        }
    }
}
