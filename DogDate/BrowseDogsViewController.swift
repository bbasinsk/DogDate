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
    var filteredDogIDs : [Int] = []
    var dogs : [Dog] = []
    var dogImages : [UIImage] = []
    var favoriteDogs : [Dog] = []
    
    var currentShelter : Shelter? = nil
    
    @IBAction func LikeDogButtonPress(_ sender: Any) {
        let button = sender as! UIButton
        self.favoriteDogs.append(self.dogs[button.tag])
        
       refreshFavorites()
    }
    
    @IBAction func UnlikeDogButtonPress(_ sender: Any) {
        let button = sender as! UIButton
        self.favoriteDogs.remove(at: self.favoriteDogs.firstIndex(of: self.dogs[button.tag]) ?? -1)
        
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
        let prevDogIDsDisplayed = self.filteredDogIDs
        // Get new shelters to be displayed after filtering
        self.filteredDogIDs = []
        for (index, searchStr) in dogSearchStrings.enumerated() {
            if searchStr.contains(searchText.lowercased()) || searchText == "" {
                self.filteredDogIDs.append(index)
            }
        }
        
        // Prevent repeated refresh of UI if no data displayed is changing
        if prevDogIDsDisplayed != self.filteredDogIDs {
            DispatchQueue.main.async {
                self.viewDidLoad()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredDogIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogViewCell", for: indexPath) as! DogViewCell
        cell.name.text = dogs[self.filteredDogIDs[indexPath.row]].name
        cell.image.image = dogImages[self.filteredDogIDs[indexPath.row]]
        
        // Set tag on button so it can be identified on click
        cell.like!.tag = self.filteredDogIDs[indexPath.row]
        cell.unlike!.tag = self.filteredDogIDs[indexPath.row]
        if favoriteDogs.contains(dogs[self.filteredDogIDs[indexPath.row]]) {
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
            let sheltersVC = segue.destination as! BrowseSheltersViewController
            sheltersVC.favoriteDogs = self.favoriteDogs
        case "dogBrowseDogDetailsViewSegue":
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let specificDogVC = segue.destination as! DogDetailsViewController
                specificDogVC.currentDog = self.dogs[self.filteredDogIDs[indexPath[0][1]]]
                specificDogVC.currentDogImage = self.dogImages[self.filteredDogIDs[indexPath[0][1]]]
                specificDogVC.currentShelter = currentShelter
            }
        default: break
        }
    }
}
