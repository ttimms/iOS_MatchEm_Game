
//  ConfigView.swift
//  MatchEmTab
//
//  Created by Tyler Timms on 11/12/18.
//  Copyright © 2018 Tyler Timms. All rights reserved.
//

import UIKit

class ConfigView: UIViewController {
    // Speed Controls
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    
    // Rectangle alpha value controls
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: UISlider!
    
    // max rectangle size controls
    @IBOutlet weak var maxSizeLabel: UILabel!
    @IBOutlet weak var maxSizeStepper: UIStepper!
    
    // min rectangle size controls
    @IBOutlet weak var minSizeLabel: UILabel!
    @IBOutlet weak var minSizeStepper: UIStepper!
    
    // Recent Game Score labels
    @IBOutlet weak var pairs1: UILabel!
    @IBOutlet weak var scores1: UILabel!
    @IBOutlet weak var pairs2: UILabel!
    @IBOutlet weak var scores2: UILabel!
    @IBOutlet weak var pairs3: UILabel!
    @IBOutlet weak var scores3: UILabel!
    
    
    // The "game" view controller
    var MatchEmVC: MatchEmScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*
        // Get a reference to the RandomRectangle's View Controller
        let tabBarControllerArray = self.tabBarController!.viewControllers
        let viewController0 = tabBarControllerArray?[0]
        MatchEmVC = viewController0 as? MatchEmScene
      */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Call functions to assign values to control labels
        setSpeedSliderAndLabel()
        setOpacitySliderAndLabel()
        setMaxSizeStepperAndLabel()
        setMinSizeStepperAndLabel()
        setRecentGameScores()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Speed Functions ============================================
    @IBAction func speedHandler(_ sender: UISlider) {
        let newSpeed = TimeInterval(sender.value)
        
        // Change the value in the other (random rect) view controller
        MatchEmVC?.newRectInterval = 1/newSpeed
        
        // Set the label text
        let speedText = String(format: "%3.1f",
                               arguments: [newSpeed])
        speedLabel.text = speedText
        
        // Note: the game will resume when we go back to the game screen
    }
    
    func setSpeedSliderAndLabel() {
        // Get the speed value from the game (random rect)
        let speed = Float(1/(MatchEmVC?.newRectInterval)!)
        
        // Set the slider
        speedSlider.value = speed
        
        // Set the label
        let speedText = String(format: "%3.1f",
                               arguments: [speed])
        speedLabel.text = speedText
    }
    
    // alpha value Functions =======================================
    @IBAction func opacityHandler(_ sender: UISlider) {
        let newOpacity = CGFloat(sender.value)
        MatchEmVC?.opacity = newOpacity
        
        let opacityText = String(format: "%3.1f",
                                 arguments: [newOpacity])
        opacityLabel.text = opacityText
    }
    
    func setOpacitySliderAndLabel() {
        let opacity = Float((MatchEmVC?.opacity)!)
        opacitySlider.value = opacity
        let opacityText = String(format: "%3.1f",
                                 arguments: [opacity])
        opacityLabel.text = opacityText
    }
    
    // Max Size Functions ==========================================
    @IBAction func maxSizeHandler(_ sender: UIStepper) {
        let newMaxSize = sender.value
        MatchEmVC?.rectSizeMax = CGFloat(newMaxSize)
        let maxSizeText = String(format: "%3.1f",
                                 arguments: [newMaxSize])
        maxSizeLabel.text = maxSizeText
    }
    
    func setMaxSizeStepperAndLabel() {
        let maxSize = Double((MatchEmVC?.rectSizeMax)!)
        maxSizeStepper.value = maxSize
        let maxSizeText = String(format: "%3.1f",
                                 arguments: [maxSize])
        maxSizeLabel.text = maxSizeText
    }
    
    
    // Min Size Functions ==========================================
    @IBAction func minSizeHandler(_ sender: UIStepper) {
        let newMinSize = sender.value
        MatchEmVC?.rectSizeMin = CGFloat(newMinSize)
        let minSizeText = String(format: "%3.1f",
                                 arguments: [newMinSize])
        minSizeLabel.text = minSizeText
    }
    
    func setMinSizeStepperAndLabel() {
        let minSize = Double((MatchEmVC?.rectSizeMin)!)
        minSizeStepper.value = minSize
        let minSizeText = String(format: "%3.1f",
                                 arguments: [minSize])
        minSizeLabel.text = minSizeText
    }
    
    // Sets the labels showing the scores from recenet games
    func setRecentGameScores(){
        let game = MatchEmVC?.game
        
        pairs1.text = String(game!.numPairs1)
        pairs2.text = String(game!.numPairs2)
        pairs3.text = String(game!.numPairs3)
        scores1.text = String(game!.score1)
        scores2.text = String(game!.score2)
        scores3.text = String(game!.score3)
    }
}
