import UIKit

var caught: Bool = false

class PokemonViewController: UIViewController {
    var url: String!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var sprite: UIImageView!
    @IBOutlet var poke_description: UITextView!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        poke_description.text = ""

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                let spriteurl = URL(string: result.sprites.front_default)
                let spritedata = try? Data(contentsOf: spriteurl!)
                let pokenumber = result.id
                
                URLSession.shared.dataTask(with: URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(pokenumber)/")!) { (pdata, presponse, perror) in
                    
                    guard let pdata = pdata else {
                        return
                    }
                    
                    do {
                        let pokeresult = try JSONDecoder().decode(PokemonSpecies.self, from: pdata)
                        loopthing: for flavor in pokeresult.flavor_text_entries {
                            if flavor.language.name == "en" {
                                let desc = flavor.flavor_text
                                DispatchQueue.main.async {
                                    self.poke_description.text = desc
                                }
                                break loopthing
                            }
                        }
                    }
                    catch let perror {
                        print(perror)
                    }
                }.resume()
                
                DispatchQueue.main.async {
                    // cant define any variables in here :D
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.sprite.image = UIImage(data: spritedata!)

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    
        caught = UserDefaults.standard.bool(forKey: current)
        if caught == false {
            catchButton.setTitle("Catch", for: .normal)
        }
        else {
            catchButton.setTitle("Release", for: .normal)
        }
    
    }
    
    @IBAction func toggleCatch() {
        if caught == false {
            catchButton.setTitle("Release", for: .normal)
            caught = true
            UserDefaults.standard.set(caught, forKey: current)
            return
        }
        else {
            catchButton.setTitle("Catch", for: .normal)
            caught = false
            UserDefaults.standard.set(caught, forKey: current)
            return
        }
    }
}
