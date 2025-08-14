//
//  ViewController.swift
//  interval-beeper
//
//  Created by yixin on 14/08/2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var switchMin1: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        Task {
            if sender.isOn {
                await scheduleNotification(interval: 60)
            }
        }
    }
    
    func scheduleNotification(interval: TimeInterval) async {
        let notificationCenter = UNUserNotificationCenter.current()

        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound])
            if !granted {
                print("Notification permission not granted")
                return
            }
        } catch {
            print("Error requesting permission: \(error)")
            return
        }
        
        // Create notification content and sound
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alert.caf"))

        // Speficy the conditions for delivery
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current


        dateComponents.weekday = 5  // Thursday
        dateComponents.hour = 12    // 12:30 hours
        dateComponents.minute = 44
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create and register a notification request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)


        // Schedule the request with the system.
        do {
            try await notificationCenter.add(request)
            print("successfully scheduled notification")
        } catch {
            // Handle errors that may occur during add.
            print("failed to schedule notification")
        }

    }
    

}

