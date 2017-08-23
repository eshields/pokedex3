//
//  Pokemon.swift
//  Pokedex 3
//
//  Created by Eric Shields on 7/30/17.
//  Copyright © 2017 Eric Shields. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _defense: String!
    private var _evolution: String!
    private var _evoID: String!
    private var _pokemonURL: String!
    private var _pokemonDescURL: String!
    
    var name: String {
        
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var height: String {
        
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String {
        
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var defense: String {
        
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var evolution: String {
        
        if _evolution == nil {
            _evolution = ""
        }
        return _evolution
    }
    
    var evoID: String {
        
        if _evoID == nil {
            _evoID = ""
        }
        return _evoID
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self ._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
        
            if let jsonData = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = jsonData["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = jsonData["height"] as? String {
                    self._height = height
                }
                
                if let attack = jsonData["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = jsonData["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = jsonData["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                else {
                    self._type = ""
                }
                
                if let evo = jsonData["evolutions"] as? [Dictionary<String,AnyObject>], evo.count > 0 {
        
                    if let nextEvo = evo[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._evolution = nextEvo
                        }
                        
                        if let level = evo[0]["level"] as? Int {
                        
                            self._evolution! += ", LVL: \(level)"
                        }
                        
                        if let nextPokemon = evo[0]["resource_uri"] as? String {
                            
                            let newStr = nextPokemon.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                            self._evoID = nextEvoID
                        }
                    }
                }
                
                if let descArray = jsonData["descriptions"] as? [Dictionary<String,String>], descArray.count > 0 {
                    
                    if let descURL = descArray[0]["resource_uri"] {
                        
                        self._pokemonDescURL = "\(URL_BASE)\(descURL)"
                        
                        Alamofire.request(self._pokemonDescURL).responseJSON(completionHandler: { (response) in
                            
                            if let json = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if var descrip = json["description"] as? String {
                                    
                                    descrip = descrip.replacingOccurrences(of: "POKMON", with: "pokemon")
                                    self._description = descrip
                                }
                            }
                            completed()
                        })

                    }
                }
                
            }
            completed()
        }
    }
}

