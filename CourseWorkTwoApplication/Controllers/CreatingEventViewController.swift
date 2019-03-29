//
//  CreatingEventViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 27/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import EventKit

class CreatingEventViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var beginEventDatePicker: UIDatePicker!
    @IBOutlet weak var endEventDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func createEventButtonPressed(_ sender: UIButton) {
        let eventStore = EKEventStore()
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event) { (granted, error) in
                if (granted && (error == nil)) {
                    self.createEvent(eventStore: eventStore, title: self.eventNameTextField.text!, startDate: self.beginEventDatePicker.date, endDate: self.endEventDatePicker.date)
                    self.showAlert()
                }
            }
            
        } else {
            createEvent(eventStore: eventStore, title: self.eventNameTextField.text!, startDate: self.beginEventDatePicker.date, endDate: self.endEventDatePicker.date)
            showAlert()
        }
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Событие", message: "Сохранено в календарь", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismissKeyboard()
            self.dismiss(animated: true, completion: nil)
            }))
        self.present(alert, animated: true, completion: nil)
    }
    

        func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch let error as NSError{
                print(error)
            }
            print("Saved")
        }
    
}
