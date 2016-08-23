//
//  onboardingViewController.swift
//  Team-Tiger
//
//  Created by Kenneth Cooke on 8/9/16.
//  Copyright © 2016 kencooke. All rights reserved.
//

import UIKit

class onboardingViewController: UIViewController {
    
    var controllerIndex: Int?
    
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var introTextLabel: UILabel!
    @IBOutlet weak var onboardingScreenshot: UIImageView!
    
    var textToDisplay: String = ""
    
    var buttonHidden: Bool = true
    var swipeHidden: Bool = false
    
    var imageForBackground: UIImage?
    var screenShot: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.introTextLabel.text = self.textToDisplay
        self.backgroundImage.image = self.imageForBackground
        self.startButton.hidden = self.buttonHidden
        self.swipeLabel.hidden = self.swipeHidden
        
        if let screenShot = self.screenShot {
            
            self.onboardingScreenshot.image = screenShot
            
        }

    }
  
}
