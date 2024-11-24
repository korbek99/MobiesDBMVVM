//
//  TopRatedViewModel.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import Foundation

class TopRatedViewModel {
    var router: Router?
    private let webService: webServicesTopRates
    
    // Datos expuestos a la vista
    private(set) var movies: [Result] = []
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    // Inicializador
    init(webService: webServicesTopRates = webServicesTopRates()) {
        self.webService = webService
    }
    
    // Método para obtener las películas
    func fetchTopRatedMovies() {
        webService.getArticles { [weak self] results in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let results = results {
                    self.movies = results
                    self.reloadData?()
                } else {
                    self.onError?("Failed to load movies." as! Error)
                    self.showError?("Failed to load movies.") // Muestra el error
                }
            }
        }
    }
    
    // Método para acceder a una película específica
    func movie(at index: Int) -> Result? {
        guard index >= 0 && index < movies.count else { return nil }
        return movies[index]
    }
}
