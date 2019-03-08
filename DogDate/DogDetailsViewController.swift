//
//  DogDetailsViewController.swift
//  DogDate
//
//  Created by Ben Basinski on 3/2/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit


class DogDetailsViewController: UIViewController {
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
    
    var currentDog : Dog? = nil
    var currentShelter : Shelter? = nil
    
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
}
