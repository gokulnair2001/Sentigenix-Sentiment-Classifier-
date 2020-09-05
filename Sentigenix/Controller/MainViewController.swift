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
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var precictionStatement: UILabel!
    
    let sentimentAnalyser = TweetSentimentIdentifier()
    
    let tweetCount = 100
    
    //Here use your own consumerkey and consumersecret key which you will get on signing up the twitter developer account
    let swifter = Swifter(consumerKey: "", consumerSecret: "")
    
    let haptic = hapticfeedback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchTextField.delegate = self
        precictionStatement.isHidden = true
        precictionLabel.isHidden = true
    }
    
    @IBAction func predictionBtn(_ sender: Any) {
        
        if SearchTextField.text != "" {
            parsingFunction()
            SearchTextField.text = ""
            haptic.haptiFeedback1()
    
            
        } else{
           /* let alert = UIAlertController(title: "Empty!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true)*/
            
            SearchTextField.placeholder = "Type Something!"
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
        
        swifter.searchTweet(using: SearchTextField.text!,lang: "en" ,count: tweetCount, tweetMode: .extended ,success: {(result, metadata) in
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
        
        if SearchTextField.text != "" {
            return true
        }else{
            SearchTextField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if SearchTextField.text != "" {
            parsingFunction()
        }
        self.SearchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        SearchTextField.endEditing(true)
        
        return true
        
    }
}


//MARK:- UI label method

extension MainViewController{
    
    func predictionResult(Score: Int){
        
        precictionStatement.isHidden = false
        precictionLabel.isHidden = false
        
        if Score > 90 {
            precictionLabel.text = "💯"
            precictionStatement.text = "Must Invest"
        }
        else if Score > 70{
            precictionLabel.text = "⭐️"
            precictionStatement.text = "Good to go"
        }
        else if Score > 40{
            precictionLabel.text = "😊"
            precictionStatement.text = "Can Try"
        }
        else if Score > 10{
            precictionLabel.text = "😅"
            precictionStatement.text = "Take Risk"
        }
        else if Score == 0{
            precictionLabel.text = "😐"
            precictionStatement.text = "Ahhh..No comments"
        }
        else if Score > -10{
            precictionLabel.text = "❌"
            precictionStatement.text = "Not now"
        }
        else if Score > -20{
            precictionLabel.text = "🛑"
            precictionStatement.text = "never"
        }
    
    }
    
}
