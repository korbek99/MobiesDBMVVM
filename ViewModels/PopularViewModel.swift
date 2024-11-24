//
//  PopularViewModel.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import Foundation

class PopularViewModel {
  
    private let webService: webServicesPopular
 
    private(set) var movies: [Result] = []
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    // Inicializador
    init(webService: webServicesPopular = webServicesPopular()) {
        self.webService = webService
    }
    
    // Método para obtener las películas
    func fetchPopularMovies() {
        webService.getArticles { [weak self] results in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let results = results {
                    self.movies = results
                    self.reloadData?()
                } else {
                    self.showError?("Failed to load movies.") 
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
