
//  MatchEmSceneController.swift
//  MatchEmTab
//
//  Created by Tyler Timms on 10/12/18.
//  Copyright © 2018 Tyler Timms. All rights reserved.
//

import UIKit

class MatchEmSceneController: UIViewController {
    
    @IBOutlet weak var gameLabel: UILabel!
    // MARK: - ==== API ====
    var newRectInterval: TimeInterval = 1.0
    var rectSizeMax: CGFloat = 150.0
    var rectSizeMin: CGFloat =  50.0
    var opacity: CGFloat = 1
    
    // MARK: ==== Management Properties ====
    private var gameInProgress = false
    private var gameRunning    = false
    
    private var newRectTimer: Timer?
    private var gameTimer: Timer?
    
    private var gameDuration: TimeInterval = 15.0
    private var timeRemaining = 0 {
        didSet { gameLabel.text = gameLabelMessage }
    }
    
    private var score = 0
    private var buttonCount = 0
    private var gameLabelMessage: String {
        return "Time: \(timeRemaining) - Pairs: \(buttonCount) - Score: \(score)"
    }
    
    var game = Game()
    private var buttonDict = [UIButton : PieceID]()
    private var pairDict = [UIButton : PairID]()
    private var defaultButton = UIButton()
    private var isSelected : UIButton?
    
    // These are not used here but are useful for MatchEm
    var firstButton:  UIButton?
    var secondButton: UIButton?
    
    // MARK: - ==== Rectangle Funcs ====
    private func createButton() {
        // Create a button
        let randSize     = randomSize()
        let randLocation = randomLocation(size: randSize)
        let randLocation2 = randomLocation(size: randSize)
        let randFrame    = CGRect(origin: randLocation, size: randSize)
        let randFrame2    = CGRect(origin: randLocation2, size: randSize)
        let button = UIButton(frame: randFrame)
        let button2 = UIButton(frame: randFrame2)
        
        // Do some button setup
        button.backgroundColor = getRandomColor()
        button2.backgroundColor = button.backgroundColor
        button.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 50)
        button2.titleLabel?.font = .systemFont(ofSize: 50)
        button.showsTouchWhenHighlighted = true
        button2.showsTouchWhenHighlighted = true
        button.isMultipleTouchEnabled = true
        button2.isMultipleTouchEnabled = true
        button.alpha = opacity
        button2.alpha = opacity
        
        // Set up target/action
        button.addTarget(self,
                         action: #selector(handlePress(sender:forEvent:)),
                         for: .touchUpInside)
        
        button2.addTarget(self,
                          action: #selector(handlePress(sender:forEvent:)),
                          for: .touchUpInside)
        
        // Count the buttons
        buttonCount += 1
        
        // Get game piece for the button
        var pieceId = game.createPiece()
        let pairId = game.makePair()
        buttonDict[button] =  pieceId
        pairDict[button] = pairId
        pieceId = game.createPiece()
        buttonDict[button2] =  pieceId
        pairDict[button2] = pairId
        
        // Make the button visible
        self.view.addSubview(button)
        self.view.addSubview(button2)
        
        // Put the game label in front of everything
        self.view.bringSubview(toFront: gameLabel)
    }
    
    func removeButton(_ theButton: UIButton) {
        theButton.removeFromSuperview()
    }
    
    func removeAllButtons() {
        for (button, _) in buttonDict {
            button.removeFromSuperview()
            buttonDict[button] = nil
        }
    }
    
    // MARK: - ==== Game Management ====
    func startNewGame() {
        // Remove buttons from the previous game
        removeAllButtons()
        
        // Init
        gameInProgress = true
        gameRunning    = true
        timeRemaining  = Int(gameDuration)
        
        buttonCount = 0
        score = 0
        
        // Start the action
        resumeGameRunning()
    }
    
    func gameOver() {
        // Stop the action
        pauseGameRunning()
        
        // No longer in progress or running
        gameInProgress = false
        gameRunning    = false
        
        // Assign the new score to the value in game object
        // Move all the other saved scores down one position
        // Discard the least recent score
        game.numPairs3 = game.numPairs2
        game.score3 = game.score2
        game.numPairs2 = game.numPairs1
        game.score2 = game.score1
        game.numPairs1 = buttonCount
        game.score1 = score
        print("pairs: \(game.numPairs1) score: \(game.score1)")
    }
    
    private func pauseGameRunning() {
        // Stop the rectangle timer
        if let timer = newRectTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.newRectTimer = nil
        
        // Stop the game timer
        if let timer = gameTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.gameTimer = nil
        
        // Debug
        print("Paused")
    }
    
    private func resumeGameRunning()
    {
        // Timer to produce the buttons
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                            repeats: true)
        { _ in self.createButton() }
        
        // Timer to control the game
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1,
                                         repeats: true)
        { _ in self.decrementCounter() }
        
        // Debug
        print("Resume")
    }
    
    func decrementCounter () {
        timeRemaining -= 1
        if timeRemaining == 0 {
            gameOver()
        }
        
        // Make sure the label is in front
        self.view.bringSubview(toFront: gameLabel)
    }
    
    // MARK: - ==== User Interaction ====
    @objc private func handlePress(sender: UIButton, forEvent event: UIEvent)
    {
        // Don't do anything if no game going on or game is paused
        if !gameInProgress || !gameRunning{
            return
        }
        
        let pieceId = buttonDict[sender]
        let pairId = pairDict[sender]
        
        
        if(pairId == pairDict[isSelected!] && pieceId != buttonDict[isSelected!]){
            removeButton(sender)
            removeButton(isSelected!)
            score += 1
        }
        else{
            isSelected!.setTitle("", for: .normal)
            isSelected = sender
            sender.setTitle("🦃", for: .normal)
        }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        if !gameInProgress {
            startNewGame()
            return
        }
        
        // We have a game in progress, pause or resume?
        if gameRunning {
            pauseGameRunning()
            gameRunning = false
            
        } else {
            resumeGameRunning()
            gameRunning = true
        }
    }
    
    // MARK: - ==== View Controller ====
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true
        buttonDict[defaultButton] = -1
        pairDict[defaultButton] = -1
        isSelected = defaultButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Game will not be running if either gameInProgress or gameRunning is false
        if gameInProgress && gameRunning {
            // A game is in progress and is running so pause it
            pauseGameRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if gameInProgress && gameRunning {
            // The game was paused in viewWillDisappear, resume it
            resumeGameRunning()
        }
    }
    
    // MARK: - ==== Misc ====
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ==== Random Value Funcs ====
    private func randomSize() -> CGSize {
        // Rect size
        let randWidth  = randomFloatZeroThroughOne() * (rectSizeMax - rectSizeMin) + rectSizeMin
        let randHeight = randomFloatZeroThroughOne() * (rectSizeMax - rectSizeMin) + rectSizeMin
        let randSize = CGSize(width: randWidth, height: randHeight)
        
        return randSize
    }
    
    private func randomLocation(size rectSize: CGSize) -> CGPoint {
        // Screen dimensions
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rectX = randomFloatZeroThroughOne() * (screenWidth  - rectSize.width)
        let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
        let location = CGPoint(x: rectX, y: rectY)
        
        return location
    }
    
    private func getRandomColor() -> UIColor {
        let randRed   = randomFloatZeroThroughOne()
        let randGreen = randomFloatZeroThroughOne()
        let randBlue  = randomFloatZeroThroughOne()
        
        let alpha:CGFloat = 1.0
        
        return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
    }
    
    private func randomFloatZeroThroughOne() -> CGFloat {
        // arc4random returns UInt32
        let randomFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        return randomFloat
    }
}

