//
//  PopularViewController.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//
import UIKit

class PopularViewController: UIViewController {
    var router: Router?
    private let viewModel = PopularViewModel()
    private var filteredMovies: [Result] = []
    private var isSearchActive: Bool = false 
    
    lazy var tableView: UITableView = {
        let table: UITableView = .init()
        table.delegate = self
        table.dataSource = self
        table.register(PopularViewCell.self, forCellReuseIdentifier: "PopularViewCell")
        table.rowHeight = 200.0
        table.separatorColor = UIColor.orange
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Movies"
        search.searchBar.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        view.backgroundColor = .white
        router = Router(navigationController: navigationController!)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        setupTableView()
        bindViewModel()
        viewModel.fetchPopularMovies() 
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
   
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource y UITableViewDelegate
extension PopularViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredMovies.count : viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularViewCell", for: indexPath) as? PopularViewCell else {
            fatalError("Could not dequeue cell with identifier: PopularViewCell")
        }
        
        let movie = isSearchActive ? filteredMovies[indexPath.row] : viewModel.movies[indexPath.row]
        cell.configure(PopularViewCellModel(
            name: movie.originalTitle,
            title: movie.title,
            lang: movie.originalLanguage,
            imagen: movie.posterPath
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedMovie = isSearchActive ? filteredMovies[indexPath.row] : viewModel.movies[indexPath.row]
        router?.navigateToDetailsPopular(with: selectedMovie)
    }
}

// MARK: - UISearchResultsUpdating
extension PopularViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            isSearchActive = false
            filteredMovies.removeAll()
            tableView.reloadData()
            return
        }
        
        isSearchActive = true
        filteredMovies = viewModel.movies.filter { movie in
            movie.title.lowercased().contains(searchText.lowercased()) ||
            movie.originalTitle.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension PopularViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredMovies.removeAll()
        tableView.reloadData()
    }
}
