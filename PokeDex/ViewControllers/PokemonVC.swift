//
//  PokemanVC.swift
//  PokeDex
//
//  Created by Seschwan on 5/31/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class PokemonVC: UIViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar:        UISearchBar!
    @IBOutlet weak var nameLbl:          UILabel!
    @IBOutlet weak var pokemanImageView: UIImageView!
    @IBOutlet weak var idLbl:            UILabel!
    @IBOutlet weak var typesLbl:         UILabel!
    @IBOutlet weak var abilitiesLbl:     UILabel!
    @IBOutlet weak var savePokemanBtn:   UIButton!
    
    var pokemonController: PokemonController?
    
    var pokemon: Pokemon? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    var hiddenOutletsVisible = false
    var searchBarVisible     = false
    var saveBtnVisible       = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savePokemanBtn.layer.cornerRadius = savePokemanBtn.frame.height/2
        searchBar.delegate = self
        hiddenOutlets(hiddenOutletsBool: hiddenOutletsVisible)
        hideSearchBar(searchBarBool: searchBarVisible)
        hideSaveBtn(saveBtnBool: saveBtnVisible)
        
        
        
    }
    
    func updateViews() {
        guard let pokemon = pokemon else { return }
        nameLbl.text = pokemon.name.capitalized
        idLbl.text = String("ID: \(pokemon.id)")
        typesLbl.text = String("Types: ") + pokemon.types.map({ $0.type.name }).joined(separator: ", ")
        abilitiesLbl.text = String("Abilities: ") + pokemon.abilities.map({ $0.ability.name }).joined(separator: ", ")
        
        pokemonController?.fetchImage(urlString: pokemon.sprites.front_default, completion: { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemanImageView.image = image
                }
            }
        })
        
    }

    // MARK: - Actions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        pokemonController?.searchForPokemon(searchTerm: searchTerm, completion: { (result, error) in
            if error != nil {
                NSLog("Error searching for pokemon")
                
            }
            self.pokemon = result
            DispatchQueue.main.async {
                self.updateViews()
            }
        })
        hiddenOutletsVisible = false
        hiddenOutlets(hiddenOutletsBool: hiddenOutletsVisible)
        saveBtnVisible = false
        hideSaveBtn(saveBtnBool: saveBtnVisible)
    }

    @IBAction func savePokeBtnPressed(_ sender: UIButton) {
        guard let pokemon = self.pokemon, isViewLoaded else { return }
        self.pokemonController?.savePokemon(pokemon: pokemon)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func hiddenOutlets(hiddenOutletsBool: Bool) {
        if hiddenOutletsBool {
            nameLbl.isHidden          = true
            pokemanImageView.isHidden = true
            idLbl.isHidden            = true
            abilitiesLbl.isHidden     = true
            typesLbl.isHidden         = true
        } else {
            nameLbl.isHidden          = false
            pokemanImageView.isHidden = false
            idLbl.isHidden            = false
            abilitiesLbl.isHidden     = false
            typesLbl.isHidden         = false
        }
    }
    
    func hideSearchBar(searchBarBool: Bool) {
        if searchBarBool {
            searchBar.isHidden = true
        } else {
            searchBar.isHidden = false
        }
    }
    
    func hideSaveBtn(saveBtnBool: Bool) {
        if saveBtnVisible {
            savePokemanBtn.isHidden = true
        } else {
            savePokemanBtn.isHidden = false
        }
    }

}
