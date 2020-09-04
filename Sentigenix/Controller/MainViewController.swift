//
//  ViewController.swift
//  Sentigenix
//
//  Created by Gokul Nair on 04/09/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class MainViewController: UIViewController {
    
   
    @IBOutlet weak var precictionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    let sentimentAnalyser = TweetSentimentIdentifier()
    
    let tweetCount = 100
    
    let swifter = Swifter(consumerKey: "w4f7LaNPGdikveanwkfrQTpgh", consumerSecret: "KsWZNHwPFpqKhriN6NaCvzBZwV36A6UIjhcwk4n7vSfBw3klay")
    
    let haptic = hapticfeedback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictionBtn(_ sender: Any) {
        
        if textField.text != "" {
            parsingFunction()
            textField.text = ""
            haptic.haptiFeedback1()
        } else{
            let alert = UIAlertController(title: "Empty!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        }
    }
    
    
    @IBAction func detailBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "details", sender: nil)
        haptic.haptiFeedback1()
    }
    
    
}

//MARK:- Parsing methods


extension MainViewController{
    
    
    func parsingFunction(){
        
        swifter.searchTweet(using: textField.text!,lang: "en" ,count: tweetCount, tweetMode: .extended ,success: {(result, metadata) in
            // print(result)
            
            var tweets = [TweetSentimentIdentifierInput]()
            
            for i in 0..<100{
                if let tweet = result[i]["full_text"].string{
                    let tweetForClasification = TweetSentimentIdentifierInput(text: tweet)
                    tweets.append(tweetForClasification)
                }
            }
            
            do{
                let predictions = try self.sentimentAnalyser.predictions(inputs: tweets)
                
                 var sentimentScore = 0
                
                for predict in predictions {
                    
                    let sentiment = predict.label
                    
                    if sentiment == "Pos" {
                        sentimentScore += 1
                    }
                    else if sentiment == "Neg" {
                        sentimentScore -= 1
                    }
                }
               
                self.predictionResult(Score: sentimentScore)
                
            }catch{
                print("error occoured\(error)")
            }
            
        }) { (error) in
            print("Error found\(error)")
        }
        
    }
}

//MARK:- Keyboard methods

extension MainViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            parsingFunction()
        }
        self.textField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


//MARK:- UI label method

extension MainViewController{
    
    func predictionResult(Score: Int){
    
        if Score > 90 {
            precictionLabel.text = "💯"
        }
        else if Score > 70{
            precictionLabel.text = "⭐️"
        }
        else if Score > 40{
            precictionLabel.text = "😊"
        }
        else if Score > 10{
            precictionLabel.text = "😅"
        }
        else if Score == 0{
            precictionLabel.text = "😐"
        }
        else if Score > -10{
            precictionLabel.text = "❌"
        }
        else if Score > -20{
            precictionLabel.text = "🛑"
        }
    
    }
    
}
