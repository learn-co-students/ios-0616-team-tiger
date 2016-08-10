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

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var introTextLabel: UILabel!
    
    var textToDisplay: String = ""
    var imageForBackground: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.introTextLabel.text = self.textToDisplay
        self.backgroundImage.image = self.imageForBackground
        
        
    }
  
    
}
