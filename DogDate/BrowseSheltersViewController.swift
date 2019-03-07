//
//  ViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

// TODO : REMOVE equatable extensions if not used. Probably going to use for favorites though to prevent duplicates - Adele

import UIKit

struct Shelter : Codable {
    var id : Int
    var name : String
    var location : String
    var hours : String
    var phone : String
    var address : String
}

extension Shelter: Equatable {
    static func == (lhs: Shelter, rhs: Shelter) -> Bool {
        return  lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.location == rhs.location &&
                lhs.hours == rhs.hours &&
                lhs.phone == rhs.phone &&
                lhs.address == rhs.address
        
    }
}

// Represents a single dog
struct Dog : Codable {
    var id : Int
    var name : String
    var breed : String
    var birthday : String
    var size : String
    var shelter : Int
    var imageURL : String
}

extension Dog: Equatable {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return  lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.breed == rhs.breed &&
            lhs.birthday == rhs.birthday &&
            lhs.size == rhs.size &&
            lhs.shelter == rhs.shelter &&
            lhs.imageURL == lhs.imageURL
        
    }
}


class BrowseSheltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var shelterSearchStrings : [String] = []
    var filteredShelterIDs : [Int] = []
    var shelters : [Shelter] = []
    var sheltersLoaded : Bool = false
    
    var dogsByShelter : [Int : [Dog]] = [:]
    var dogsByShelterSearchStrings : [Int : [String]] = [:]
    var dogsLoaded : Bool = false
    var dogImagesByShelter : [Int: [UIImage]] = [:]
    
    
    // If search bar value is updated
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let prevShelterIDsDisplayed = self.filteredShelterIDs
        
        // Get new shelters to be displayed after filtering
        self.filteredShelterIDs = []
        for (index, searchStr) in shelterSearchStrings.enumerated() {
            if searchStr.contains(searchText.lowercased()) || searchText == "" {
                self.filteredShelterIDs.append(index)
            }
        }
        
        // Prevent repeated refresh of UI if no data displayed is changing
        if prevShelterIDsDisplayed != self.filteredShelterIDs {
            DispatchQueue.main.async {
                self.viewDidLoad()
            }
        }
    }
    
    @IBAction func unwindToBrowseShelters(segue:UIStoryboardSegue) { }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredShelterIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shelterViewCell", for: indexPath) as! ShelterViewCell
        cell.name.text = self.shelters[self.filteredShelterIDs[indexPath.row]].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 309, height: 210)
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
                self.shelters = try JSONDecoder().decode([Shelter].self, from:dataResponse)
                self.filteredShelterIDs = Array(0...(self.shelters.count - 1))
                
                // Create searchable strings
                for shelter in self.shelters {
                    self.shelterSearchStrings.append((shelter.name + " " + shelter.address + " " + shelter.location + " " + shelter.address).lowercased())
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
                let dogs = try JSONDecoder().decode([Dog].self, from:dataResponse)
                for dog in dogs {
                    if self.dogsByShelter[dog.shelter] == nil {
                        self.dogsByShelter[dog.shelter] = []
                        self.dogsByShelterSearchStrings[dog.shelter] = []
                        self.dogImagesByShelter[dog.shelter] = []
                    }
                    self.dogsByShelter[dog.shelter]!.append(dog)
                    let newSearchStr = dog.name + " " + dog.breed + " " + dog.birthday + " " + dog.size + "size"
                    self.dogsByShelterSearchStrings[dog.shelter]!.append(newSearchStr.lowercased())
                    // Get dog image
                    if let url = NSURL(string: dog.imageURL) {
                        if let data = NSData(contentsOf: url as URL) {
                            self.dogImagesByShelter[dog.shelter]!.append(UIImage(data: data as Data)!)
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
        if sheltersLoaded && !dogsLoaded { fetchDogJSON() }
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        SearchBar.delegate = self
    }
    
    // Pass on details about dog and shelter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems {
            let browseDogsVC = segue.destination as! BrowseDogsViewController
            browseDogsVC.currentShelter = self.shelters[self.filteredShelterIDs[indexPath[0][1]]]
            browseDogsVC.dogs = self.dogsByShelter[indexPath[0][1] + 1]!
            browseDogsVC.dogSearchStrings = self.dogsByShelterSearchStrings[indexPath[0][1] + 1]!
            browseDogsVC.dogImages = self.dogImagesByShelter[indexPath[0][1] + 1]!
            browseDogsVC.filteredDogIDs = Array(0...(self.dogsByShelter[indexPath[0][1] + 1]!.count - 1))
        }
    }
}

