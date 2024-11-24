//
//  TopRatesViewController.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//
import UIKit

class TopRatesViewController: UIViewController {
    var router: Router?
    private let viewModel = TopRatedViewModel()
    private var filteredMovies: [Result] = []
    private var isSearchActive: Bool = false

    lazy var tableView: UITableView = {
        let table: UITableView = .init()
        table.delegate = self
        table.dataSource = self
        table.register(TopRatesViewCell.self, forCellReuseIdentifier: "TopRatesViewCell")
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
        title = "Top Rates"
        router = Router(navigationController: navigationController!)
        view.backgroundColor = .white

//        viewModel.showError = { [weak self] errorMessage in
//            //self?.presentErrorViewController(with: errorMessage)
//            router?.showError(error: errorMessage)
//        }
        
        viewModel.showError = { [weak self] error in
            self?.router?.showError(error: error)
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        setupTableView()
        bindViewModel()
        viewModel.fetchTopRatedMovies()
    }
    
    func presentErrorViewController(with errorMessage: String) {
        AppRouter.shared.showError(from: self, message: errorMessage)
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
extension TopRatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredMovies.count : viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatesViewCell", for: indexPath) as? TopRatesViewCell else {
            fatalError("Could not dequeue cell with identifier: TopRatesViewCell")
        }
        
        let movie = isSearchActive ? filteredMovies[indexPath.row] : viewModel.movies[indexPath.row]
        cell.configure(TopRatesViewCellModel(
            name: movie.originalTitle,
            title: movie.title,
            lang: movie.originalLanguage,
            imagen: movie.posterPath
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMovie = isSearchActive ? filteredMovies[indexPath.row] : viewModel.movies[indexPath.row]
        router?.navigateToDetailsTop(with: selectedMovie)
    }
}


// MARK: - UISearchResultsUpdating
extension TopRatesViewController: UISearchResultsUpdating {
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
extension TopRatesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        filteredMovies.removeAll()
        tableView.reloadData()
    }
}
