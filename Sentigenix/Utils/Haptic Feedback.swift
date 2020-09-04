//
//  Haptic Feedback.swift
//  Sentigenix
//
//  Created by Gokul Nair on 05/09/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import Foundation
import AVKit

class hapticfeedback {
    
    func haptiFeedback1() {
    //print("haptick done")
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
    }
    
    func haptiFeedback2() {
    //print("haptick done")
    let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
}
