//
//  UIImageView+Extension.swift
//  PokeApi
//
//  Created by Alejandro Mendoza on 10/23/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async {
            [weak self] in if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
