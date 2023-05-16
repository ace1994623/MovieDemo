//
//  MovieDetailView.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit
import SDWebImage

class MovieDetailView: UIView {
    // MARK: - Properties
    /// To display the name of the movie
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    /// To display the release date of the movie
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    /// To display the scroll view to put image and overview in
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// To display the overview of the movie
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    /// To display the poster image
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(frame: CGRect, dataModel: MoviesInfoModel) {
        self.init(frame: frame)
        updateData(dataModel: dataModel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // Add title label and apply constraint
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        // Add release date label and apply constraint
        addSubview(releaseDateLabel)
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        ])
        
        // Add scroll view and apply constraint
        addSubview(contentScrollView)
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 16),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        // Add poster image view and apply constraint
        contentScrollView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor, constant: -16),
        ])
        
        // Add overview label and apply constraint
        contentScrollView.addSubview(overviewLabel)
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public Methods
    func updateData(dataModel: MoviesInfoModel) {
        // Update name of movie
        titleLabel.text = dataModel.title
        
        // Update release date
        releaseDateLabel.text = dataModel.releaseDate
        
        // Update overview
        overviewLabel.text = dataModel.overview
        
        // Update poster image
        posterImageView.setImage(urlString: ImageDownloadHelper.getImageDownlaodUrlString(
            path: dataModel.posterPath ?? "",
            size: .big,
            type: .poster)) {
                // Calculate the scaled heigt of image to show propriate size
                NSLayoutConstraint.activate([
                    self.posterImageView.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor),
                    self.posterImageView.leadingAnchor.constraint(equalTo: self.contentScrollView.leadingAnchor, constant: 8),
                    self.posterImageView.widthAnchor.constraint(equalTo: self.contentScrollView.widthAnchor, constant: -16),
                    self.posterImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / (self.posterImageView.image?.size.width ?? 1) * (self.posterImageView.image?.size.height ?? 1))
                ])
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
    }
}
