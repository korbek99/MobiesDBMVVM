//
//  ErrorViewController.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import UIKit

class ErrorViewController: UIViewController {
    var errorMessage: String?
    
    lazy var labelError: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = view.bounds
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Error"
        view.backgroundColor = .white
        setupUX()
        loadData()
    }
    
    func loadData() {
        labelError.text = errorMessage
    }
    
    func setupUX() {
        view.backgroundColor = .white
        view.addSubview(labelError)
        NSLayoutConstraint.activate([
            labelError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelError.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelError.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
}

