//
//  MoviesTableViewCell.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/4/29.
//

import UIKit
import SDWebImage

class MoviesTableViewCell: UITableViewCell {
    // MARK: - Lazy load properties
    /// To display the name of the movie
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    /// To display the release date of the movie
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    /// To display the poster image
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI();
    }
    
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, dataModel: MoviesInfoModel) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        updateData(dataModel: dataModel);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func setupUI() {
        // Add poster imageview and apply constraint
        contentView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add releasedate label and apply constraint
        contentView.addSubview(releaseDateLabel)
        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Add title label and apply constraint
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: releaseDateLabel.topAnchor, constant: -10)
        ])
    }
    
    // MARK: - Public
    func updateData(dataModel: MoviesInfoModel) {
        titleLabel.text = dataModel.title
        releaseDateLabel.text = dataModel.releaseDate
        posterImageView.setImage(urlString: ImageDownloadHelper.getImageDownlaodUrlString(
            path: dataModel.posterPath ?? "",
            size: .small,
            type: .poster)) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
    }
}
