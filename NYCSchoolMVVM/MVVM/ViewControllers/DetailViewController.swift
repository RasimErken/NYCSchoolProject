//
//  SecondViewController.swift
//  MVVM
//
//  Created by rasim rifat erken on 7.08.2022.
//

import UIKit
import MapKit
import CoreLocation
import NotificationCenter


class DetailViewController: UIViewController {
    
    var latitudeDouble : Double?
    var longitudeDouble : Double?
    var school : String?
   
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var numberOfTestTakers: UILabel!
    @IBOutlet weak var averageMathScore: UILabel!
    @IBOutlet weak var averageReadingScore: UILabel!
    @IBOutlet weak var averageWritingScore: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var satScore: School?
    var schoolScore : SatSchool?
    var location : String?
    var longitude : String?
    var latitude : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = schoolScore?.location
        if let b = location?.components(separatedBy: " ") {
            longitude = b[b.count-1]
            latitude = b[b.count-2]
        }
        latitude?.removeFirst()
        longitude?.removeLast()
        latitude?.removeLast()
        
        latitudeDouble = Double(latitude ?? "40.111")
        longitudeDouble = Double(longitude ?? "40.111")
        
        
    
        addHSAnnotaionWithCoordinates(CLLocationCoordinate2D(latitude: latitudeDouble!, longitude: longitudeDouble!))
        
        hideNilData()
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.incomingNotification(_:)), name:  NSNotification.Name(rawValue: "notificationName"), object: nil)
        }
        
    }
    
    @objc func incomingNotification(_ notification: Notification) {
        if let text = notification.userInfo?["text"] as? String {
            print(text)

        }
    }
    @IBAction func websiteButton(_ sender: Any) {
        NotificationClass.instance.notification(body: "You have entered \(schoolScore!.school_name)'s website" , notification: "Website Notification")
        
        var website = schoolScore?.website
        if (schoolScore?.website.hasPrefix("www.") == true ) {
            website = website?.replacingOccurrences(of: "www.", with: "https://")
        } else if schoolScore?.website.hasPrefix("http://") == true {
        } else {
            website = "https://\(website ?? "a")"
        }
        
        guard let string = website else { return }
        guard let url = URL(string: string) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func phoneButton(_ sender: Any) {
        let schoolPhoneNumber = schoolScore?.phone_number
        if let url = URL(string: "tel://\(String(describing: schoolPhoneNumber))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else{
            let alertView = UIAlertController(title: "Error!", message: "Please run on a real device to call \(schoolPhoneNumber!)", preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertView.addAction(okayAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        schoolName.text = satScore?.school_name
        schoolName.textColor = .systemRed
        numberOfTestTakers.text = satScore?.num_of_sat_test_takers
        averageReadingScore.text = satScore?.sat_critical_reading_avg_score
        averageWritingScore.text = satScore?.sat_writing_avg_score
        averageMathScore.text = satScore?.sat_math_avg_score
        textField.text = schoolScore?.overview_paragraph
        city.text = schoolScore?.city
        city.textColor = .systemBlue
        website.setTitle("Go to School Website", for: .normal)
        phoneButton.setTitle(schoolScore?.phone_number, for: .normal)
        
        schoolName.numberOfLines = 0
        
    }
    
    func addHSAnnotaionWithCoordinates(_ hsCoordinates: CLLocationCoordinate2D){
        
        let highSchoolAnnotation = MKPointAnnotation()
        highSchoolAnnotation.coordinate = hsCoordinates
        self.mapView.addAnnotation(highSchoolAnnotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: highSchoolAnnotation.coordinate, span: span)
        let adjustRegion = self.mapView.regionThatFits(region)
        self.mapView.setRegion(adjustRegion, animated:true)
    }
    
    func hideNilData(){
        if schoolScore?.location == nil {
            mapView.isHidden = true
        }
        
        if schoolScore?.overview_paragraph == nil {
            textField.isHidden = true
        }
        
        if schoolScore?.website == nil {
            website.isHidden = true
        }
        
        if schoolScore?.phone_number == nil {
            phoneButton.isHidden = true
        }
    }
    
    
}




