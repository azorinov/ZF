//
//  ImageUtil.swift
//  Zen Fringe
//
//  Created by Alexander Zorinov on 15/03/15.
//  Copyright (c) 2015 TS. All rights reserved.
//

import UIKit

struct Theme {
    static let normalBackground = UIColor.white
    static let redStone = UIColor(red:255/255, green:0/255, blue:0/255, alpha:1.0).cgColor
    static let redSuccess = UIColor(red:250/255, green:55/255, blue:100/255, alpha:1.0)
}

struct ImageUtil {
    func getFeedbackCounter() ->Int {
        let defaults = UserDefaults.standard
        let counter = defaults.integer(forKey: "feedbackCounter")
        return counter
    }
    
    func setFeedbackCounter() {
        let defaults = UserDefaults.standard
        var counter = defaults.integer(forKey: "feedbackCounter")
        counter+=1
        if counter < 3 {
            defaults.set(counter, forKey: "feedbackCounter")
        }
    }
    
    func getGameDemoCounter() ->Int {
        let defaults = UserDefaults.standard
        let counter = defaults.integer(forKey: "gameDemoCounter")
        return counter
    }
    
    func setGameDemoCounter() {
        let defaults = UserDefaults.standard
        var counter = defaults.integer(forKey: "gameDemoCounter")
        counter+=1
        defaults.set(counter, forKey: "gameDemoCounter")
    }
    
    func getGameLaunchCounter() ->Int {
        let defaults = UserDefaults.standard
        let counter = defaults.integer(forKey: "gameLaunchCounter")
        return counter
    }
    
    func setGameLaunchCounter() {
        let defaults = UserDefaults.standard
        var counter = defaults.integer(forKey: "gameLaunchCounter")
        counter+=1
        defaults.set(counter, forKey: "gameLaunchCounter")
    }
    
    func randomBetweenNumbers() -> CGFloat{
        var firstNum = 20.0
        var secondNum = 300.0
        
        if UIScreen.main.nativeBounds.height == 1334 {
            firstNum = 20.0
            secondNum = 355.0
        } else if UIScreen.main.nativeBounds.height == 2208 {
            firstNum = 20.0
            secondNum = 386.0
        }
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func getSuccessColor() ->UIColor {
        return Theme.redSuccess
    }
}
