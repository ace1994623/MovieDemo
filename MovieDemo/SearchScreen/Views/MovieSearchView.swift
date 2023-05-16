//
//  MovieSearchView.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit

class MovieSerchView: UIView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    typealias ClickSearchBlock = (_ searchText: String) -> Void
    typealias ClickMovieBlock = (_ movieDetail: MoviesInfoModel) -> Void
    typealias LoadNextPageBlock = (_ nextPage: Int, _ searchText: String) -> Void
    
    // MARK: - Properties
    /// The key string to search movie info
    var searchText: String?
    /// Search reasult data list
    var movieList: [MoviesInfoModel] = []
    /// Ueser click search button callback
    var onClickSearchBlock: ClickSearchBlock?
    /// Ueser click on specific row callback
    var onClickMovieBlock: ClickMovieBlock?
    /// Load data of next page callback
    var onLoadNextPageBlock: LoadNextPageBlock?
    /// Current loaded page
    var currentPage: Int = 0
    /// Total pages
    var totalPage: Int = 0

    
    // MARK: - Lazy load properties
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type a keyword of movies to search"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.autocapitalizationType = .none
        return searchBar
    }()

    /// Table view to show the search results
    lazy var resultTableView: UITableView = {
        let resultTableView = UITableView()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.translatesAutoresizingMaskIntoConstraints = false
        return resultTableView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(frame: CGRect,
                     clickSearchCallback: @escaping ClickSearchBlock,
                     clickMovieCallback: @escaping ClickMovieBlock,
                     loadNextpageCallback: @escaping LoadNextPageBlock) {
        self.init(frame: frame)
        self.onClickSearchBlock = clickSearchCallback
        self.onClickMovieBlock = clickMovieCallback
        self.onLoadNextPageBlock = loadNextpageCallback
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        self.addSubview(searchBar)
        self.addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            resultTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    // MARK: - Public Methods
    /*
     Refresh the table view with new data or load next page data based on the flag
     */
    func updateData(datalist: MoviesListModel, isNextPage: Bool) {
        if isNextPage {
            // Add one more page to tableview if it is load next page
            movieList += datalist.results ?? [];
        } else {
            // Update data list of movie if it is a data for new search
            movieList = datalist.results ?? [];
        }
        
        // Update current page and total page
        currentPage = datalist.page ?? 1
        totalPage = datalist.totalPages ?? 1
        
        // Refresh tableview
        resultTableView.reloadData()
    }
    
    // MARK: - Pagination
    /*
     Check if need to request data for next page and make request
     */
    private func requestNextPageIfNeed(currentIndex: Int) {
        if let keyword = searchText,
           let block = self.onLoadNextPageBlock,
           currentIndex == movieList.count - 1,
           currentPage < totalPage {
            // If the table view is reach the bottm and has next page, request for load next page
            block(currentPage + 1, keyword)
        }
    }
    
    // MARK: - UISearchBarDelegate
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        
        // Hide the keyboard
        searchBar.resignFirstResponder()
        
        // If the text is empty or only contains white space, show alert to user
        if keyword.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            // TODO: show alert cannot serach empty word
        } else if let block = self.onClickSearchBlock {
            // Update the search string
            searchText = keyword
            // Call back the controller
            block(keyword)
        }
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
        
        if let block = self.onClickMovieBlock {
            // Callback viewcontroller when user click on a specific row
            block(movieList[indexPath.row])
        }
    }
    
    // MARK: - UITableViewDataSource
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check if need to load more page
        requestNextPageIfNeed(currentIndex: indexPath.row)
        
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
