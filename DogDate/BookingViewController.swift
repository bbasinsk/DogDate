//
//  BookingViewController.swift
//  DogDate
//
//  Created by Rhea on 3/11/19.
//  Copyright © 2019 Ben Basinski. All rights reserved.
//

import UIKit
import EventKit

class BookingViewController: UIViewController {
	
	@IBOutlet weak var bookButton: UIButton!
	@IBOutlet weak var DogImage: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		bookButton.applyDesign()

		
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
