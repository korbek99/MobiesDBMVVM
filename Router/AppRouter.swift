//
//  AppRouter.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 21-11-19.
//

import Foundation
import UIKit

class AppRouter {
    static let shared = AppRouter()

    var navigationController: UINavigationController?
    
    private init() {
        navigationController = UINavigationController()
    }

    func showError(from viewController: UIViewController, message: String) {
        let errorVC = ErrorViewController()
        errorVC.errorMessage = message
        viewController.navigationController?.pushViewController(errorVC, animated: true)
    }

    func showErrorViewController(with error: Error) {
        guard let navigationController = navigationController else {
            print("Error: navigationController no está inicializado.")
            return
        }
        
        let errorViewController = ErrorViewController()
        errorViewController.errorMessage = error.localizedDescription
        navigationController.pushViewController(errorViewController, animated: true)
    }

    func setNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

