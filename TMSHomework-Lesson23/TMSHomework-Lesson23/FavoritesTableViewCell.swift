//
//  FavoritesTableViewCell.swift
//  TMSHomework-Lesson23
//
//  Created by Наталья Мазур on 19.02.24.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    lazy var bookmarkImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBookmarkImage()
        setupUrlLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupBookmarkImage() {
        addSubview(bookmarkImage)
        
        NSLayoutConstraint.activate([
            bookmarkImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bookmarkImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupUrlLabel() {
        addSubview(urlLabel)
        
        NSLayoutConstraint.activate([
            urlLabel.leadingAnchor.constraint(equalTo: bookmarkImage.trailingAnchor, constant: 20),
            urlLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(savedURL: SavedURL) {
        bookmarkImage.image = UIImage(systemName: savedURL.imageName)
        urlLabel.text = "\(savedURL.savedURL)"
    }
}
