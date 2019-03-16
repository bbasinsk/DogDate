//
//  DogDetailsViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit


class DogDetailsViewController: UIViewController {
    
    var dogSearchStrings : [String] = []
    var filteredDogs : [Int] = []
    var dogs : [Dog] = []
    var favoriteDogs : [Dog] = []
    var currentShelter : Shelter? = nil
    var currentDog : Dog? = nil
    
    @IBOutlet weak var DogImageView: UIImageView!
    
    @IBOutlet weak var DogSizeLabel: UILabel!
    @IBOutlet weak var DogBirthdayLabel: UILabel!
    @IBOutlet weak var DogBreedLabel: UILabel!
    @IBOutlet weak var DogNameLabel: UILabel!
    
    @IBOutlet weak var ShelterNameLabel: UILabel!
    @IBOutlet weak var ShelterHoursLabel: UILabel!
    @IBOutlet weak var ShelterPhoneNumberLabel: UILabel!
    @IBOutlet weak var ShelterAddressLabel: UILabel!
    @IBOutlet weak var ShelterLocationLabel: UILabel!
    
    @IBAction func call(_ sender: Any) {
        let phone = currentShelter!.shelter.phone
        var num = ""
        let digitSet = "0123456789"
        for i in phone {
            if digitSet.contains(i) {
                // is digit!
                num += String(i)
            }
        }
        guard let number = URL(string: "tel://" + num) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func share(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [DogImageView.image!], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DogNameLabel.text = "Name: " + currentDog!.dog.name
        DogBreedLabel.text = "Breed: " + currentDog!.dog.breed
        DogBirthdayLabel.text = "Birthday: " + currentDog!.dog.birthday
        DogSizeLabel.text = "Size: " + currentDog!.dog.size
        DogImageView.image = currentDog?.dogImage
        
        ShelterNameLabel.text = "I'm at " + currentShelter!.shelter.name + "!"
        ShelterHoursLabel.text = "Hours: " + currentShelter!.shelter.hours
        ShelterPhoneNumberLabel.text = "Phone: " + currentShelter!.shelter.phone
        ShelterAddressLabel.text = currentShelter!.shelter.address
        ShelterLocationLabel.text = currentShelter!.shelter.location
    }
    
    // Pass back details about dog to the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailToBooking":
            let detailVC = segue.destination as! BookingViewController
            detailVC.dogSearchStrings = self.dogSearchStrings
            detailVC.filteredDogs = self.filteredDogs
            detailVC.dogs = self.dogs
            detailVC.currentShelter = self.currentShelter
            detailVC.currentDog = self.currentDog
        case "detailToDog":
            let detailVC = segue.destination as! BrowseDogsViewController
            detailVC.dogSearchStrings = self.dogSearchStrings
            detailVC.filteredDogs = self.filteredDogs
            detailVC.dogs = self.dogs
            detailVC.currentShelter = self.currentShelter
        default: break
        }
    }
    
}
