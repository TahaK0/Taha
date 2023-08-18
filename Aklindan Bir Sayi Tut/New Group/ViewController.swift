//
//  ViewController.swift
//  Aklindan Bir Sayi Tut
//
//  Created by Taha Karakaş on 11.08.2023.
//

import UIKit
import AVFoundation


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


class ViewController: UIViewController, UITextFieldDelegate {
    
 
    @IBOutlet weak var tahminTextField: UITextField!
    @IBOutlet weak var buton1: UIButton!
    @IBOutlet weak var buton3: UIButton!
    @IBOutlet weak var buton4: UIButton!
    @IBOutlet weak var ipucuLabel: UILabel!
    @IBOutlet weak var buton5: UIButton!
    @IBOutlet weak var buton6: UIButton!
  
    @IBOutlet weak var tahminButon: UIButton!
    @IBOutlet weak var tema2: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        applyTheme()
        gercekSayi = generateRandomNumber(upperBound: 50)
        updateRemainingAttemptsLabel()
        ipucuLabel.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceModeChanged), name: UIAccessibility.darkerSystemColorsStatusDidChangeNotification, object: nil)
        
      
    }
   
    var tahmin = 0
    var gercekSayi = 0
    var hak = 5
    var player: AVAudioPlayer!
    var isDarkMode = false
    var darkBackgroundColor = UIColor(hex: "26272D")
    var darkTextColor = UIColor(hex: "FFFCE1")
    var acikrenk = UIColor(hex: "FFF500")
    var acikrenk2 = UIColor(hex: "F6F4EB")
    var acikrenk3 = UIColor(hex: "C3FFF4")
    
    
    
    func updateRemainingAttemptsLabel() {
        if hak == 4 {
            buton6.alpha = 0.5
            animateButtonBreakEffect()
        }else if hak == 3 {
            buton5.alpha = 0.5
            animateButtonBreakEffect()
        }else if hak == 2 {
            buton1.alpha = 0.5
            animateButtonBreakEffect()
        }else if hak == 1 {
            buton3.alpha = 0.5
            animateButtonBreakEffect()
        }else if hak == 0 {
            buton4.alpha = 0.5
            animateButtonBreakEffect()
                        
        }
        
        
    }
    /// FONKSIYONLAR
    @objc func appearanceModeChanged() {
           applyTheme()
       }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        print("Trait collection changed")
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // The appearance mode has changed, update the theme
            applyTheme()
        }
    }
    
    
    func darkModeChanged() {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                  
                self.applyTheme()
            }, completion: nil)
        }

    func applyTheme() {
         if traitCollection.userInterfaceStyle == .dark {
                // Koyu tema renklerini burada uygula
            isDarkMode = true
             view.backgroundColor = darkBackgroundColor
             tahminTextField.textColor = darkTextColor
             ipucuLabel.textColor = darkTextColor
             
             tahminButon.backgroundColor = darkTextColor
            } else {
                // Açık tema renklerini burada uygula
                view.backgroundColor = acikrenk2
                tahminTextField.textColor = .darkGray
                ipucuLabel.textColor = .darkGray
                
                tahminButon.backgroundColor = acikrenk3
                
            }
        }
   
    func generateRandomNumber(upperBound: Int) -> Int {
        return Int.random(in: 1...upperBound)
    }
    func feedbackVibrate() { //Cihaz Titresme efekti.
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
        
    }
    func feedbackVibrate2() { //Cihaz Titresme efekti.
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.warning)
        
    }
    func animateButtonBreakEffect() { //Kalp Saydamlasma animasyonu.
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        buton1.layer.add(animation, forKey: "fade")
        buton3.layer.add(animation, forKey: "fade")
        buton4.layer.add(animation, forKey: "fade")
        buton5.layer.add(animation, forKey: "fade")
        buton6.layer.add(animation, forKey: "fade")
       
        
    }
    func shakeThatAss() { //Text field sallanma animasyonu.
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: tahminTextField.center.x - 10, y: tahminTextField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: tahminTextField.center.x + 10, y: tahminTextField.center.y))
        
        tahminTextField.layer.add(animation, forKey: "position")
    }
    func showHintWithFadeIn() {
        ipucuLabel.alpha = 0.0 // Başlangıçta labelı görünmez yapın
        ipucuLabel.text = "Tahmininizi Azaltin!" // İpucu metni
        
        UIView.animate(withDuration: 0.5, animations: {
            self.ipucuLabel.alpha = 1.0 // Animasyonla labelı yavaşça görünür yapın
        })
    }
    
    func showHintWithFadeIn2() {
        ipucuLabel.alpha = 0.0 // Başlangıçta labelı görünmez yapın
        ipucuLabel.text = "Tahminizi Yukseltin!" // İpucu metni
        
        UIView.animate(withDuration: 0.5, animations: {
            self.ipucuLabel.alpha = 1.0 // Animasyonla labelı yavaşça görünür yapın
        })
    }
  
   
    


    @IBAction func tahminButtonPressed(_ sender: UIButton) {
        
        let url = Bundle.main.url(forResource: "buton", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        
        if tahminTextField.text?.isEmpty ?? true { // Kullanici bos girerse textfield sallanacak.
            shakeThatAss()
          
            return
        }
    
        
        if hak > 0 {
            if let tahmin = tahminTextField.text, let guess = Int(tahmin) {
                updateRemainingAttemptsLabel()
                if guess > gercekSayi {
                    hak -= 1
                    feedbackVibrate2()
                    updateRemainingAttemptsLabel()
                    shakeThatAss()
                    showHintWithFadeIn()
                    tahminTextField.text?.removeAll()
                    
                    
                }else if guess < gercekSayi{
                    hak -= 1
                    feedbackVibrate2()
                    updateRemainingAttemptsLabel()
                    shakeThatAss()
                    showHintWithFadeIn2()
                    tahminTextField.text?.removeAll()
                    
                    
                    
                }else{
                    feedbackVibrate()
                    updateRemainingAttemptsLabel()
                    
                    self.performSegue(withIdentifier: "goToResult", sender: self)
                    
                }
            }
        }
        
            if hak == 0 {
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController /// Ikinci ekranin UIViewController'ina geciyor.
            destinationVC.gercekSayi = gercekSayi
            destinationVC.hak = hak
            destinationVC.guess = Int(tahminTextField.text!) ?? 0
            destinationVC.isDarkMode = isDarkMode
            destinationVC.applyTheme()
        }
    
       
    }
   
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true) // Klavyeyi gizler
        }
    }
    

