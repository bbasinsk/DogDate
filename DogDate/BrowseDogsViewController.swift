//
//  BrowseDogsViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit


class BrowseDogsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBAction func unwindToBrowseDogs(segue:UIStoryboardSegue) { }
    
    var dogSearchStrings : [String] = []
    
    var currentShelter : Shelter? = nil
    
    @IBAction func LikeDogButtonPress(_ sender: Any) {
        let button = sender as! UIButton
        favoriteDogs.append(dogs[button.tag])
        
        saveFavorites()
        refreshFavorites()
    }
    
    
    // Stores user favorites to file
    func saveFavorites() {
        do {
            var jsonDogs : [JSONDog] = []
            for dog in favoriteDogs {
                jsonDogs.append(dog.dog)
            }
            let jsonData = try JSONEncoder().encode(jsonDogs)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let dir = NSHomeDirectory()
            try jsonString.write(to: URL(fileURLWithPath: (dir + "/favoritedogs.json")), atomically: true, encoding: .utf8)
        } catch { print(error) }
    }
    
    
    @IBAction func UnlikeDogButtonPress(_ sender: Any) {
        let button = sender as! UIButton
        favoriteDogs.remove(at: favoriteDogs.firstIndex(of: dogs[button.tag]) ?? -1)
        
        refreshFavorites()
    }
    
    
    func refreshFavorites() {
        UIView.setAnimationsEnabled(false)
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
    }
    
    
    // If search bar value is updated
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let prevDogIDsDisplayed = filteredDogs
        // Get new shelters to be displayed after filtering
        filteredDogs = []
        for (index, dog) in dogs.enumerated() {
            if dog.searchString.contains(searchText.lowercased()) || searchText == "" {
                filteredDogs.append(index)
            }
        }
        
        // Prevent repeated refresh of UI if no data displayed is changing
        if prevDogIDsDisplayed != filteredDogs {
            DispatchQueue.main.async {
                self.viewDidLoad()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDogs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogViewCell", for: indexPath) as! DogViewCell
        cell.name.text = dogs[filteredDogs[indexPath.row]].dog.name
        cell.image.image = dogs[filteredDogs[indexPath.row]].dogImage
        
        // Set tag on button so it can be identified on click
        cell.like!.tag = filteredDogs[indexPath.row]
        cell.unlike!.tag = filteredDogs[indexPath.row]
        
        if favoriteDogs.contains(dogs[filteredDogs[indexPath.row]]) {
            cell.like!.isHidden = true
            cell.unlike!.isHidden = false
        } else {
            cell.like!.isHidden = false
            cell.unlike!.isHidden = true
        }
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        SearchBar.delegate = self
        UIView.setAnimationsEnabled(true)
    }
    
    
    // Pass on details about dog and shelter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToSheltersSegue":
            return
        case "dogBrowseDogDetailsViewSegue":
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let specificDogVC = segue.destination as! DogDetailsViewController
                specificDogVC.currentDog = dogs[filteredDogs[indexPath[0][1]]]
                specificDogVC.currentShelter = currentShelter
                specificDogVC.dogSearchStrings = self.dogSearchStrings
            }
        default: break
        }
    }
}
