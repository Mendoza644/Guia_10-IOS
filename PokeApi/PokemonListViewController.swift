//
//  ViewController.swift
//  PokeApi
//
//  Created by Alejandro Mendoza on 10/23/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.//

import UIKit
import Foundation

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var nextResultsButton: UIButton!
    @IBOutlet weak var loadQueryButton: UIButton!
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    @IBOutlet weak var previousResultsButton: UIButton!
    
    let pokeDataSource: PokeDataSource = PokeDataSource()
    
    lazy var presenter: PokemonListPresenterProtocol = PokemonListPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeCollectionView.dataSource = pokeDataSource
        pokeCollectionView.delegate = self
        presenter.loadInitialPokemonList()
        
        let searchController = UISearchController(searchResultsController: nil)
        let reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(reloadList))
        searchController.searchBar.delegate = self
        searchController.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem = reloadButton
    }
    
    @objc private func reloadList(){
        self.presenter.updateFilteredView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showPokemonInfo",
            let detailVC = segue.destination as? PokemonDetailViewController,
            let name = sender as? String {
            detailVC.pokemonName = name
        }
    }
    
    @IBAction func loadQueryFromSearchBar(_ sender: Any) {
        presenter.fetchPokemonWithQuery()
    }
    
    @IBAction func didSelectPreviousResults(_ sender: Any) {
        presenter.fetchMoreResults(for: .previous)
    }
    
    @IBAction func didSelectNextResults(_ sender: Any) {
        presenter.fetchMoreResults(for: .next)
    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let pokemonName = pokeDataSource.getPokemonNames()[indexPath.row].name
        self.performSegue(withIdentifier: "showPokemonInfo", sender: pokemonName)
    }
}

extension PokemonListViewController: PokemonListViewProtocol {
    func enableButtonLoading(for buttonVisibility: ButtonVisibility) {
        previousResultsButton.isHidden = buttonVisibility.0
        nextResultsButton.isHidden = buttonVisibility.1
    }
    
    func refreshPokeCollectionView(with pokemonData: PokemonData) {
        self.pokeDataSource.setPokemonNames(pokemonNames: pokemonData.results)
        self.pokeCollectionView.reloadData()
    }
    
    func showEmptyMessage() {
        pokeCollectionView.isHidden = true
        loadQueryButton.isHidden = false
    }
    
    func hideEmptyMessage() {
        pokeCollectionView.isHidden = false
        loadQueryButton.isHidden = true
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.searchPokemonInList(with: searchText)
    }
}

extension PokemonListViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.reloadList()
    }
}

