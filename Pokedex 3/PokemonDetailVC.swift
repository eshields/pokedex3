//
//  PokemonDetailVC.swift
//  Pokedex 3
//
//  Created by Eric Shields on 8/13/17.
//  Copyright © 2017 Eric Shields. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        
        let img = UIImage(named: "\(self.pokemon.pokedexId)")
        
        pokeImage.image = img
        currentEvoImg.image = img
        
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetails {
            // Whatever we write here will be done after network download is complete
            self.updateUI()
        }
        
    }
    
    func updateUI() {

        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.baseAttack
        descriptionLbl.text = pokemon.description
        
        if pokemon.evolution == ""{
            nextEvoImg.isHidden = true
            evolutionLbl.text = "No Evolution"
        }
        else {
            evolutionLbl.text = "Next Evolution: \(pokemon.evolution)"
            nextEvoImg.image = UIImage(named: "\(pokemon.evoID)")
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

}
