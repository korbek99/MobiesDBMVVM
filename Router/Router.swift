//
//  Router.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import Foundation
import UIKit

class Router {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToDetailsTop(with movie: Result) {
        let detailsViewController = TopDetailsViewController()
        detailsViewController.movies = [movie]
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    func navigateToDetailsPopular(with movie: Result) {
        let detailsViewController = PopularDetailsViewController()
        detailsViewController.movies = [movie]
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    func showError(error: String){
        let viewController = ErrorViewController()
        viewController.errorMessage = error
        navigationController.pushViewController(viewController, animated: true)
    }
}
