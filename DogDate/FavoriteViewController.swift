//
//  FavoritesViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func UnlikeDogPress(_ sender: Any) {
        let button = sender as! UIButton
        favoriteDogs.remove(at: button.tag)
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
    
    func refreshFavorites() {
        UIView.setAnimationsEnabled(false)
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteDogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favViewCell", for: indexPath) as! FavViewCell
        cell.name.text = favoriteDogs[indexPath.row].dog.name
        cell.image.image = favoriteDogs[indexPath.row].dogImage
        cell.UnlikeButton.tag = indexPath.row
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        UIView.setAnimationsEnabled(true)
    }
    
    // Pass on details about favorite dogs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToBrowseSheltersWithSegue":
            return
        default: break
        }
    }
}
