//
//  BookingViewController.swift
//  DogDate
//
//  Created by Rhea on 3/11/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit
import EventKit
import CallKit

class BookingViewController: UIViewController {
	
    @IBOutlet weak var bookButton: UIButton!

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var beginField: UITextField!
    @IBOutlet weak var endField: UITextField!

    var currentDog : Dog? = nil
    var currentShelter : Shelter? = nil
	
	override func viewDidLoad() {
        super.viewDidLoad()
        bookButton.applyDesign()
        dogNameLabel.text = currentDog!.dog.name
        dogImage.image = currentDog?.dogImage
        contactButton.setTitle("" + currentShelter!.shelter.phone, for: .normal)
        locationButton.setTitle("" + currentShelter!.shelter.address, for: .normal)
		
//		DogNameLabel.text = "Name: " + currentDog!.dog.name
//		DogBreedLabel.text = "Breed: " + currentDog!.dog.breed
//		DogBirthdayLabel.text = "Birthday: " + currentDog!.dog.birthday
//		DogSizeLabel.text = "Size: " + currentDog!.dog.size
//		DogImageView.image = currentDog?.dogImage
//
//		ShelterNameLabel.text = "I'm at " + currentShelter!.shelter.name + "!"
//		ShelterHoursLabel.text = "Hours: " + currentShelter!.shelter.hours
//		ShelterPhoneNumberLabel.text = "Phone: " + currentShelter!.shelter.phone
//		ShelterAddressLabel.text = currentShelter!.shelter.address
//		ShelterLocationLabel.text = currentShelter!.shelter.location

		
    }
    

	
}

extension UIButton {
	func applyDesign() {
		self.backgroundColor = UIColor.blue
		self.layer.cornerRadius = self.frame.height / 2
		self.setTitleColor(UIColor.white, for: .normal)
		
//		self.layer.shadowColor = UIColor.red.cgColor
//		self.layer.shadowRadius = 8
	}
}

//extension UIImageView {
//	func applyFrame() {
//
//	}
//}
