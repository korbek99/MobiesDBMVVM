//
//  PopularCollectionViewCell.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private lazy var imgMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(imgMovie)
        
        // Add constraints to imgMovie
        NSLayoutConstraint.activate([
            imgMovie.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with image: UIImage?) {
        imgMovie.image = image
    }
}
