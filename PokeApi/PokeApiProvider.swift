//
//  PokeApiProvider.swift
//  PokeApi
//
//  Created by Alejandro Mendoza on 10/23/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation
import Alamofire

struct PokemonData: Decodable {
    let next: String?
    let previous: String?
    let results: [PokemonResult]
    
    struct PokemonResult: Decodable {
        let name: String
        let url: String
    }
    
    static func empty() -> PokemonData {
        return PokemonData(next: nil, previous: nil, results: [])
    }

}

protocol HTTPRequestProvider {
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonDetailInfo?) -> ())
    func getPokemonList(with resultTypeURL: String?, completionHandler: @escaping (PokemonData?)->())
}

class PokeApiProvider: HTTPRequestProvider{
    static let baseURL: String = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemonBy(name: String, completionHandler: @escaping (PokemonDetailInfo?)-> ()){
        AF.request("\(PokeApiProvider.baseURL)\(name)", method: .get, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseData { response in
            
            switch response.result {
            case .success:
                if let data = response.data{
                    do {
                        let pokemonDeatailInfo = try JSONDecoder().decode(PokemonDetailInfo.self, from: data)
                        completionHandler(pokemonDeatailInfo)
                    }catch let error{
                        completionHandler(nil)
                        print(error)
                    }
                }
                
            case let .failure(error):
                completionHandler(nil)
                print(error)
            }
        }
    }
    
    func getPokemonList(with resultTypeURL: String?, completionHandler: @escaping (PokemonData?) -> ()) {
        
        var url = "\(PokeApiProvider.baseURL)?limit=150"
        
        if let resultURL = resultTypeURL {
            url = resultURL
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                        completionHandler(pokemonData)
                    } catch let error {
                        print(error)
                    }
                    
                case .failure(let error):
                    completionHandler(nil)
                    print(error)
                }
        }
    }
    
    //private func parseJsonResult(jsonResult: [String: Any]) -> PokemonData? {
        //if let pokemonName = jsonResult["name"] as? String,
        //let pokemonWeight = jsonResult["weight"] as? Int,
        //let spritesDict = jsonResult["sprites"] as? [String: Any],
        //let otherArtworkDict = spritesDict["other"] as? [String: Any],
        //let officialArtworkDict = otherArtworkDict["official-artwork"] as? [String: Any],
            //let officialArtwork = officialArtworkDict["front_default"] as? String {
            //return PokemonData(name: pokemonName, officialImage:  officialArtwork, weight: pokemonWeight)
        //}
        //return nil
    //}
}
