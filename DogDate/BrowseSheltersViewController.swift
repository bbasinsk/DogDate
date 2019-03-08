//
//  ViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

// TODO : REMOVE equatable extensions if not used. Probably going to use for favorites though to prevent duplicates - Adele

import UIKit

struct JSONShelter : Codable {
    var id : Int
    var name : String
    var location : String
    var hours : String
    var phone : String
    var address : String
}

struct Shelter {
    var shelter : JSONShelter
    var searchString : String
}

extension Shelter: Equatable {
    static func == (lhs: Shelter, rhs: Shelter) -> Bool {
        return  lhs.shelter.id == rhs.shelter.id &&
                lhs.shelter.name == rhs.shelter.name &&
                lhs.shelter.location == rhs.shelter.location &&
                lhs.shelter.hours == rhs.shelter.hours &&
                lhs.shelter.phone == rhs.shelter.phone &&
                lhs.shelter.address == rhs.shelter.address
    }
}

// Represents a single dog read directly from JSON
struct JSONDog : Codable {
    var id : Int
    var name : String
    var breed : String
    var birthday : String
    var size : String
    var shelter : Int
    var imageURL : String
}

// Represents a single dog with the image
// and search string for the dog
struct Dog {
    var dog : JSONDog
    var dogImage : UIImage
    var searchString : String
}

extension Dog: Equatable {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return  lhs.dog.id == rhs.dog.id &&
            lhs.dog.name == rhs.dog.name &&
            lhs.dog.breed == rhs.dog.breed &&
            lhs.dog.birthday == rhs.dog.birthday &&
            lhs.dog.size == rhs.dog.size &&
            lhs.dog.shelter == rhs.dog.shelter &&
            lhs.dog.imageURL == lhs.dog.imageURL
    }
}


class BrowseSheltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var filteredShelters : [Int] = []
    var shelters : [Shelter] = []
    var sheltersLoaded : Bool = false
    
    var dogsByShelter : [Int : [Dog]] = [:]
    var dogsLoaded : Bool = false
    var favoriteDogs : [Dog] = []
    
    // If search bar value is updated
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let prevShelterIDsDisplayed = self.filteredShelters
        
        // Get new shelters to be displayed after filtering
        self.filteredShelters = []
        for (index, shelter) in shelters.enumerated() {
            if shelter.searchString.contains(searchText.lowercased()) || searchText == "" {
                self.filteredShelters.append(index)
            }
        }
        
        // Prevent repeated refresh of UI if no data displayed is changing
        if prevShelterIDsDisplayed != self.filteredShelters {
            DispatchQueue.main.async {
                self.viewDidLoad()
            }
        }
    }
    
    
    @IBAction func unwindToBrowseShelters(segue:UIStoryboardSegue) { }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredShelters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shelterViewCell", for: indexPath) as! ShelterViewCell
        cell.name.text = self.shelters[self.filteredShelters[indexPath.row]].shelter.name
        return cell
    }
    
    
    // Fetches and parses Shelter JSON data
    func fetchShelterJSON() {
        let urlString : String = "https://dogdate-api.herokuapp.com/shelters"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    let errorString : String = error?.localizedDescription ?? "Response Error"
                    
                    let alert = UIAlertController(title: "Error Downloading Shelter Details", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            do {
                let JSONShelters = try JSONDecoder().decode([JSONShelter].self, from:dataResponse)
                self.filteredShelters = Array(0...(JSONShelters.count - 1))
                
                // Create Shelter structs
                for shelter in JSONShelters {
                    let searchString : String = (shelter.name + " " + shelter.address + " " + shelter.location + " " + shelter.address)
                    self.shelters.append(Shelter(shelter: shelter, searchString: searchString.lowercased()))
                }
                
                self.sheltersLoaded = true
                DispatchQueue.main.async {
                    self.viewDidLoad()
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    
    // Loads user's favorite dogs if they exist
    func loadFavorites() {
        do {
            let dir = NSHomeDirectory()
            let dataResponse = try Data(contentsOf: URL(fileURLWithPath: (dir + "/favoritedogs.json")))
            let JSONDogs : [JSONDog] = try JSONDecoder().decode([JSONDog].self, from: dataResponse)
            
            // Reconstruct search string and get image for dog
            for dog in JSONDogs {
                let searchString : String = dog.name + " " + dog.breed + " " + dog.birthday + " " + dog.size
                // Get dog image
                if let url = NSURL(string: dog.imageURL) {
                    if let data = NSData(contentsOf: url as URL) {
                        self.favoriteDogs.append(Dog(dog: dog, dogImage: UIImage(data: data as Data)!, searchString: searchString.lowercased()))
                    }
                }
            }
        } catch {
            print("Could not get favorite dogs.")
        }
    }
    
    
    // Fetches and parses Dog JSON data
    func fetchDogJSON() {
        let urlString : String = "https://dogdate-api.herokuapp.com/dogs"
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    let errorString : String = error?.localizedDescription ?? "Response Error"
                    
                    let alert = UIAlertController(title: "Error Downloading Dog Details", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            do {
                let JSONDogs = try JSONDecoder().decode([JSONDog].self, from:dataResponse)
                for dog in JSONDogs {
                    if self.dogsByShelter[dog.shelter] == nil {
                        self.dogsByShelter[dog.shelter] = []
                    }
                    
                    let searchString : String = dog.name + " " + dog.breed + " " + dog.birthday + " " + dog.size
                    // Get dog image
                    if let url = NSURL(string: dog.imageURL) {
                        if let data = NSData(contentsOf: url as URL) {
                            self.dogsByShelter[dog.shelter]!.append(Dog(dog: dog, dogImage: UIImage(data: data as Data)!, searchString: searchString.lowercased()))
                        }
                    }
                }
                
                self.dogsLoaded = true
                DispatchQueue.main.async {
                    self.viewDidLoad()
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        if !sheltersLoaded { fetchShelterJSON() }
        if sheltersLoaded && !dogsLoaded {
            fetchDogJSON()
            loadFavorites()
        }
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        SearchBar.delegate = self
    }
    
    
    // Pass on details about dog and shelter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "shelterToFavoritesSegue":
            let favoriteDogsVC = segue.destination as! FavoriteViewController
            favoriteDogsVC.favoriteDogs = self.favoriteDogs
        default:
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let browseDogsVC = segue.destination as! BrowseDogsViewController
                browseDogsVC.currentShelter = self.shelters[self.filteredShelters[indexPath[0][1]]]
                browseDogsVC.dogs = self.dogsByShelter[self.filteredShelters[indexPath[0][1]] + 1]!
                browseDogsVC.filteredDogs = Array(0...(self.dogsByShelter[indexPath[0][1] + 1]!.count - 1))
                browseDogsVC.favoriteDogs = self.favoriteDogs
            }
        }
    }
}

