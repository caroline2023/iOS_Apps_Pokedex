import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let sprites: sprites
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct sprites: Codable {
    let front_default: String
    let back_default: String
}

struct PokemonSpecies: Codable{
    let id: Int
    let flavor_text_entries: [flavor_text_entry]
}

struct flavor_text_entry: Codable {
    let flavor_text: String
    let language: language
}

struct language: Codable{
    let name: String
}
