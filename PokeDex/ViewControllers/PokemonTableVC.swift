//
//  PokemanTableVC.swift
//  PokeDex
//
//  Created by Seschwan on 5/31/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class PokemonTableVC: UITableViewController {
    
    let pokemonController = PokemonController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return pokemonController.pokemanArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let pokemonCell = self.pokemonController.pokemanArray[indexPath.row]
        cell.textLabel?.text = pokemonCell.name.capitalized
        print("TableView: ")
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemon = self.pokemonController.pokemanArray[indexPath.row]
            self.pokemonController.delete(pokemon: pokemon)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSearchPokedex" {
            guard let pokemonVC = segue.destination as? PokemonVC else { return }
            pokemonVC.pokemonController = self.pokemonController
            pokemonVC.hiddenOutlets = true
        } else if segue.identifier == "ToPokeDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let pokemonVC = segue.destination as? PokemonVC else { return }
            let pokemon = self.pokemonController.pokemanArray[indexPath.row]
            pokemonVC.pokemon = pokemon
            pokemonVC.pokemonController = self.pokemonController
            pokemonVC.searchBarBool = true
            
        }
    }
    
}
