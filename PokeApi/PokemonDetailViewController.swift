//
//  PokemonDetailViewController.swift
//  PokeApi
//
//  Created by Alejandro Mendoza on 10/23/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation
import UIKit

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var PokeAvatar: UIImageView!
    @IBOutlet weak var PokeWeightLabel: UILabel!
    @IBOutlet weak var PokeNameLabel: UILabel!
    
    var pokemonName: String = ""
    var pokemonApi: HTTPRequestProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonApi = PokeApiProvider()
        pokemonApi?.getPokemonBy(name: pokemonName) { [weak self] pokemonData in guard let `self` = self,
            let pokemonData = pokemonData else {return}
            
            self.PokeNameLabel.text = pokemonData.name.capitalized
            self.PokeWeightLabel.text = self.calculateWeightInLbs(from: pokemonData.weight)
            if let url = URL(string: pokemonData.officialImage) {
                self.PokeAvatar.load(url: url)
            }
        }
    }
    
    private func calculateWeightInLbs(from hectograms: Int) -> String {
        let factor = 4.536 // 1 hectogram = 0.220462
        let conversion = Double(hectograms)/factor
        let weight = String(format: "%.01f", conversion)
        return "\(weight) lbs"
    }
}
