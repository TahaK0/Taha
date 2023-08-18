//
//  ResultViewController.swift
//  Aklindan Bir Sayi Tut
//
//  Created by Taha Karakaş on 11.08.2023.
//

import UIKit
import AVFoundation
class ResultViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

   
    
    
    @IBOutlet weak var buton1: UIButton!
    
    var hak = 3
    var gercekSayi = 0
    var guess = 0
    var player: AVAudioPlayer!
    var isDarkMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceModeChanged), name: UIAccessibility.darkerSystemColorsStatusDidChangeNotification, object: nil)
    }
    func applyTheme() {
         if traitCollection.userInterfaceStyle == .dark {
                // Koyu tema renklerini burada uygula
            isDarkMode = true
                view.backgroundColor = UIColor(hex: "26272D")
                label1.textColor = UIColor(hex: "FFFCE1")
                label2.textColor = UIColor(hex: "FFFCE1")
                buton1.backgroundColor = UIColor(hex: "FFFCE1")
            } else {
                // Açık tema renklerini burada uygula
                isDarkMode = false
                view.backgroundColor =  UIColor(hex: "F6F4EB")
                
                buton1.backgroundColor = UIColor(hex: "C3FFF4")
            }
        }
    @objc func appearanceModeChanged() {
           applyTheme()
       }

       
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // The appearance mode has changed, update the theme
            applyTheme()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetButtonOpacity()
        applyTheme()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
       
        
        feedbackVibrate()
        
        self.dismiss(animated: true)
        if let mainVC = self.presentingViewController as? ViewController {
            mainVC.gercekSayi = mainVC.generateRandomNumber(upperBound: 50)
            mainVC.hak = 5
            mainVC.updateRemainingAttemptsLabel()
            mainVC.tahminTextField.text?.removeAll()
        }
    }

    func feedbackVibrate() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
    }

    func feedbackVibrate2() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.warning)
    }

    func updateLabels() {
        if  guess == gercekSayi {
            label1.text = "Tebrikler!"
            label2.text = "Dogru tahmin!"
            feedbackVibrate()
            
            let url = Bundle.main.url(forResource: "Apple Pay Success Sound Effect", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            
        } else if hak == 0 {
            label1.text = "Üzgünüz!"
            label2.text = "Dogru Sayi: \(gercekSayi)"
            feedbackVibrate2()
        }
    }
        

    func resetButtonOpacity() {
        if let mainVC = self.presentingViewController as? ViewController {
            mainVC.buton1.alpha = 1.0
            mainVC.buton3.alpha = 1.0
            mainVC.buton4.alpha = 1.0
            mainVC.buton5.alpha = 1.0
            mainVC.buton6.alpha = 1.0
            mainVC.ipucuLabel.text = ""
            // Burada tüm butonları, uygulamanıza göre isimlendirilmiş doğru buton referansları ile sıfırlamalısınız.
        }
    }
}
