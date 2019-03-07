//
//  BrowseDogsViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit

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

class BrowseDogsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func unwindToBrowseDogs(segue:UIStoryboardSegue) { }
    
    var dogs : [Dog] = []
    var dogsLoaded : Bool = false
    var images : [UIImage] = []
    var currentShelter : Shelter? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogViewCell", for: indexPath) as! DogViewCell
        cell.name.text = dogs[indexPath.row].name
        if let url = NSURL(string: dogs[indexPath.row].imageURL) {
            if let data = NSData(contentsOf: url as URL) {
                cell.image.image = UIImage(data: data as Data)
                images.append(cell.image.image!)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 120)
    }
    
    // Fetches JSON code from user specified URL
    func fetchJSON() {
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
                // Decode JSON
                let response_dogs = try JSONDecoder().decode([Dog].self, from:dataResponse)
                for dog in response_dogs {
                    if dog.shelter == 1 {
                        self.dogs.append(dog)
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
        if !dogsLoaded { fetchJSON() }
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // Pass on details about dog and shelter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "dogBrowseDogDetailsViewSegue":
            if let indexPath = collectionView.indexPathsForSelectedItems {
                let specificDogVC = segue.destination as! DogDetailsViewController
                specificDogVC.currentDog = self.dogs[indexPath[0][1]]
                specificDogVC.currentDogImage = images[indexPath[0][1]]
                specificDogVC.currentShelter = currentShelter
            }
        default: break            
        }
    }
}
