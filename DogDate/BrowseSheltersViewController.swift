//
//  ViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit

struct Shelter {
    let name: String
    let image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

class BrowseSheltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let shelters = [Shelter(name: "Seattle Animal Shelter", image: "none"), Shelter(name: "Seattle Dog Lovers", image: "none")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shelters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shelterViewCell", for: indexPath) as! ShelterViewCell
        cell.name.text = shelters[indexPath.row].name
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadSections(IndexSet(integer: 0))
        // Do any additional setup after loading the view, typically from a nib.
    }


}

