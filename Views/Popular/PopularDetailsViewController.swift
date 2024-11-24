//
//  PopularDetailsViewController.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//
import UIKit

class PopularDetailsViewController: UIViewController {
    var movies: [Result] = []
    var baseurl = "http://image.tmdb.org/t/p/w500"
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lblName: UILabel = createLabel(font: UIFont.boldSystemFont(ofSize: 20.0), textColor: .black)
    private lazy var lblDescription: UILabel = createLabel(font: UIFont.boldSystemFont(ofSize: 20.0), textColor: .lightGray)
    private lazy var lblLang: UILabel = createLabel(font: UIFont.boldSystemFont(ofSize: 20.0), textColor: .orange)
    
    private lazy var imgMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        setupUI()
        loadData()
    }
    
    private func loadData() {
        guard let movie = movies.first else { return }
        
        lblName.text = movie.title
        lblDescription.text = movie.originalTitle
        lblLang.text = "Language: " + (movie.originalLanguage.uppercased() )
        
        guard !movie.posterPath.isEmpty, let imageURL = URL(string: baseurl + movie.posterPath) else {
            imgMovie.image = UIImage(named: "placeholder")
            return
        }
        
        imgMovie.loadImage(from: imageURL, placeholder: UIImage(named: "placeholder"))
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [lblName, lblDescription, lblLang, imgMovie].forEach { contentView.addSubview($0) }
        
        setupScrollViewConstraints()
        setupContentViewConstraints()

        setupImageViewConstraints()
        setupLabelsConstraints()
    }
    
    // MARK: - Helper Functions
    private func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = font
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            imgMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imgMovie.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgMovie.heightAnchor.constraint(equalToConstant: 400),
            imgMovie.widthAnchor.constraint(equalToConstant: 400)
        ])
    }

    private func setupLabelsConstraints() {
        NSLayoutConstraint.activate([
            lblName.topAnchor.constraint(equalTo: imgMovie.bottomAnchor, constant: 20),
            lblName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lblName.heightAnchor.constraint(equalToConstant: 20),
            
            lblDescription.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 10),
            lblDescription.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lblDescription.heightAnchor.constraint(equalToConstant: 50),
            
            lblLang.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
            lblLang.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lblLang.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
