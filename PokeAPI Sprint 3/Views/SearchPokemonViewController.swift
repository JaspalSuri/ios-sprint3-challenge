import UIKit

class SearchPokemonViewController: UIViewController, UISearchBarDelegate {
    
    // Pokemon Name
    @IBOutlet weak var pokemonNameLabel: UILabel!
    // Pokemon ID
    @IBOutlet weak var pokemonIDLabel: UILabel!
    // Pokemon Type(s)
    @IBOutlet weak var pokemonTypesLabel: UILabel!
    // Pokemon Abilities
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    // Pokemon Sprite/Image
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    // Save Pokemon that is in the results.
    @IBAction func savePokemon(_ sender: Any) {
        // Connect to our model and call on the save Pokemon function to save it to our dedicated array.
        PokedexModel.shared.savePokemon()
        
        // Pop back into previous view after saving pokemon
        navigationController?.popViewController(animated: true)
    }
    
    // Relocate this to the model if necessary.
    var pokemonSearchResult: Pokemon?
    
    // In case we need to connect to our API...
    let pokemonSearchResultsController = PokemonSearchResultsController()
    
    // SearchBar Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Set it to something (elsewhere) or remove completely
    @IBOutlet weak var searchResultsVCTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up searchbar delegate in viewDidLoad
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Something we added from a different project.
        searchBar.resignFirstResponder()
        
        // Creates a constant set to the text in the searchbar and checks if it's empty.
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        // Sets the searchbar text to empty after it has been used
        searchBar.text = ""
        // Creates a cool gray placeholder to show what the user typed in
        // which is more neat than useful in this case, given our data
        searchBar.placeholder = searchTerm
        
        func updateSearchResults() {
            
            // if let pokemonSearchResult = pokemonSearchResult {
                
                guard let presentedPokemon = PokedexModel.shared.selectedPokemon else { fatalError("Could not obtain Pokemon.")}
                
                self.pokemonNameLabel.text = presentedPokemon.name
                self.pokemonIDLabel.text = "ID: \(presentedPokemon.id)"
                
                self.pokemonTypesLabel.text = "Types: "
                
                self.pokemonAbilitiesLabel.text = "Abilities: "
                
                // Unwrap the URL if a valid, non-empty sprite is returned
                guard let urlString = presentedPokemon.sprites?.frontDefault else { return }
                // Set the link to the image
                guard let imageURL = URL(string: urlString), let imageData = try? Data(contentsOf: imageURL) else { fatalError("Couldn't obtain image.")}
                // Set the ImageView to the imageData in the form of a usable UIImage
                self.pokemonSpriteImageView?.image = UIImage(data: imageData)
        //    }
         }
        
        pokemonSearchResultsController.performSearch(searchTerm: searchTerm) { _ in
            DispatchQueue.main.async {
                // self.pokemonSearchResult = PokemonSearchResultsController.shared.pokemonSearchResults[IndexPath]
                updateSearchResults()
            }
        }
    }
}

