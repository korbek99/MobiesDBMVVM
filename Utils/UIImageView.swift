//
//  UIImageView.swift
//  MobiesDBMVVM
//
//  Created by Jose Preatorian on 23-11-19.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        // Establece una imagen de marcador de posición
        self.image = placeholder
        
        // Carga la imagen de forma asíncrona
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                error == nil
            else {
                print("Error cargando la imagen: \(String(describing: error))")
                return
            }
            
            // Actualiza la UI en el hilo principal
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
