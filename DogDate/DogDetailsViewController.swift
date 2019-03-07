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
    var currentDogImage : UIImage? = nil
    var currentShelter : Shelter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DogNameLabel.text = "Name: " + currentDog!.name
        DogBreedLabel.text = "Breed: " + currentDog!.breed
        DogBirthdayLabel.text = "Birthday: " + currentDog!.birthday
        DogSizeLabel.text = "Size: " + currentDog!.size
        DogImageView.image = currentDogImage!
        
        ShelterNameLabel.text = "I'm at " + currentShelter!.name + "!"
        ShelterHoursLabel.text = "Hours: " + currentShelter!.hours
        ShelterPhoneNumberLabel.text = "Phone: " + currentShelter!.phone
        ShelterAddressLabel.text = currentShelter!.address
        ShelterLocationLabel.text = currentShelter!.location
    }
}
