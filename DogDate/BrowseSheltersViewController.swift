//
//  ViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit

struct Shelter : Codable {
    var id : Int
    var name : String
    var location : String
    var hours : String
    var phone : String
    var address : String
}

class BrowseSheltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var shelters : [Shelter] = []
    var sheltersLoaded : Bool = false
    
    @IBAction func unwindToBrowseShelters(segue:UIStoryboardSegue) { }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shelters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shelterViewCell", for: indexPath) as! ShelterViewCell
        cell.name.text = shelters[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 309, height: 210)
    }
    
    // Fetches JSON code from user specified URL
    func fetchJSON() {
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
                // Decode JSON
                self.shelters = try JSONDecoder().decode([Shelter].self, from:dataResponse)
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
    
    
    override func viewDidLoad() {
        if !sheltersLoaded { fetchJSON() }
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    
        self.collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    // Pass on details about dog and shelter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems {
            let browseDogsVC = segue.destination as! BrowseDogsViewController
            browseDogsVC.currentShelter = shelters[indexPath[0][1]]
        }
    }
}

