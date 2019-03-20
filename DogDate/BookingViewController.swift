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
import MapKit
import UserNotifications
import UserNotificationsUI

class BookingViewController: UIViewController {
    
    var dogSearchStrings : [String] = []
    var currentShelter : Shelter? = nil
    var currentDog : Dog? = nil
	
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var beginDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    let dateBeginPicker = UIDatePicker()
    let dateEndPicker = UIDatePicker()
    
    @IBAction func bookDate(_ sender: Any) {
        if (dateEndPicker.date > dateBeginPicker.date) {
            //Notification Content
            let content = UNMutableNotificationContent()
            content.title = "Dog Date Reminder"
            content.subtitle = beginDate.text!
            content.body = currentShelter!.shelter.address
            content.categoryIdentifier = "reminder"
            content.sound = UNNotificationSound.default
            
            //Notification Trigger - when the notification should be fired
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            //Notification Request
            let request = UNNotificationRequest(identifier: "Anniversary", content: content, trigger: trigger)
            
            //Scheduling the Notification
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
            }
            //alert if the date is booked
            let alert = UIAlertController(title: "Book a date", message: "Success", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in
                self.performSegue(withIdentifier: "bookingToDetail", sender: nil)}))
            self.present(alert, animated: true, completion: {})
        } else {
            //alert if end date is earlier than begin date
            let alert = UIAlertController(title: "Warning", message: "End date should not be earlier than begin date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in}))
            self.present(alert, animated: true, completion: {})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ask for permission for notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            //granted = yes, if app is authorized for all of the requested interaction types
            //granted = no, if one or more interaction type is disallowed
        }
        bookButton.applyDesign()
        bookButton.isEnabled = false
        dogNameLabel.text = currentDog!.dog.name
        dogImage.image = currentDog?.dogImage
        contactButton.setTitle("" + currentShelter!.shelter.phone, for: .normal)
        locationButton.setTitle("" + currentShelter!.shelter.address, for: .normal)
        locationButton.titleLabel?.numberOfLines = 2
        //set default begin date
        dateEndPicker.isEnabled = false
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        beginDate.text = formatter.string(from: dateBeginPicker.date)
        showDatePicker(string: "begin")
        showDatePicker(string: "end")
    }
    
    func showDatePicker(string : String){
        
        //ToolBar for done and cancel button
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        switch string {
        case "begin":
            dateBeginPicker.datePickerMode = .dateAndTime
            dateBeginPicker.minimumDate = NSDate() as Date
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedateBeginPicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            beginDate.inputAccessoryView = toolbar
            beginDate.inputView = dateBeginPicker
        default:
            dateEndPicker.isEnabled = true
            dateEndPicker.datePickerMode = .dateAndTime
            dateEndPicker.minimumDate = NSDate() as Date
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedateEndPicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            endDate.inputAccessoryView = toolbar
            endDate.inputView = dateEndPicker
        }
        
    }
    
    //for choosing begin date
    @objc func donedateBeginPicker(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        beginDate.text = formatter.string(from: dateBeginPicker.date)
        self.view.endEditing(true)
    }
    
    //for choosing end date
    @objc func donedateEndPicker(){
        if (dateEndPicker.date > dateBeginPicker.date) {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = DateFormatter.Style.short
            endDate.text = formatter.string(from: dateEndPicker.date)
            bookButton.isEnabled = true
            self.view.endEditing(true)
        } else {
            //alert if end date is earlier than begin date
            let alert = UIAlertController(title: "Warning", message: "End date should not be earlier than begin date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { _ in}))
            self.present(alert, animated: true, completion: {})
        }
    }
    
    @objc func cancelDatePicker(date: UITextField){
        self.view.endEditing(true)
    }
    
    @IBAction func onCallTap(_ sender: Any) {
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
    
    @IBAction func onLocationTap(_ sender: Any) {
        let address = currentShelter!.shelter.address
        let name = currentShelter!.shelter.name
        let phone = currentShelter!.shelter.phone
        
        coordinates(forAddress: address) {
            (location) in
            guard let location = location else { return }
            
            let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = name
            mapItem.phoneNumber = phone
            mapItem.openInMaps(launchOptions: nil)
        }
    }
    
    
    // Pass back details about dog to the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "bookingToDetail":
            let detailVC = segue.destination as! DogDetailsViewController
            detailVC.dogSearchStrings = self.dogSearchStrings
            detailVC.currentShelter = self.currentShelter
            detailVC.currentDog = self.currentDog
        default: break
        }
    }
	
}

extension UIButton {
	func applyDesign() {
		self.backgroundColor = UIColor.blue
		self.layer.cornerRadius = self.frame.height / 2
		self.setTitleColor(UIColor.white, for: .normal)
	}
}

func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) {
        (placemarks, error) in
        guard error == nil else {
            print("Geocoding error: \(error!)")
            completion(nil)
            return
        }
        completion(placemarks?.first?.location?.coordinate)
    }
}
