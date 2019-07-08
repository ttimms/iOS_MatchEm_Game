//
//  ViewController.swift
//  RandomRectangles
//
//  Created by Tyler Timms on 10/12/18.
//  Copyright © 2018 Tyler Timms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameLabel: UILabel!
    
    // MARK: - Game Play Properties
    private let rectSizeMin: CGFloat =  50.0
    private let rectSizeMax: CGFloat = 150.0
    
    // MARK: ==== Management Properties ====
    //private var theButton: UIButton?
    private var game = Game()
    private var buttonDict = [UIButton : PieceID]()
    private var pairDict = [UIButton : PairID]()
    private var defaultButton = UIButton()
    private var isSelected : UIButton?
    
    private var newRectTimer: Timer?
    private var newRectInterval: TimeInterval = 1.0
    private var gameTimer: Timer?
    private var gameDuration: TimeInterval = 15.0
    private var Time = 15
    
    private var score = 0
    
    private var buttonCount = 0 {
        didSet {
            gameLabel.text = gameLabelMessage
        }
    }
    private var gameLabelMessage: String {
        return "Time: \(Time) - Pairs: \(buttonCount) - Score: \(score)"
    }
    
    // MARK: - ==== Rectangle Funcs ====
    private func createButton() {
        Time -= 1
        // Create a button
        //let buttonFrame = CGRect(x: 50, y: 50, width: 80, height: 40)
        let randSize     = randomSize()
        let randLocation = randomLocation(size: randSize)
        let randLocation2 = randomLocation(size: randSize)
        let randFrame    = CGRect(origin: randLocation, size: randSize)
        let randFrame2    = CGRect(origin: randLocation2, size: randSize)
        let button = UIButton(frame: randFrame)
        let button2 = UIButton(frame: randFrame2)
        
        // Keep a reference
        //theButton = button
        
        // Do some setup
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
        
        // Set up target/action
        button.addTarget(self,
                         action: #selector(handlePress(sender:)),
                         for: .touchUpInside)
        
        button2.addTarget(self,
                         action: #selector(handlePress(sender:)),
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
        
        self.view.bringSubview(toFront: gameLabel)
    }
    
    func removeButton(_ theButton: UIButton) {
        // Optional chaining
        theButton.removeFromSuperview()
        //theButton = nil
    }
    
    // MARK: - ==== Timer Stuff ====
    private func startGameRunning()
    {
        // Timer to produce the buttons
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                            repeats: true)
        { _ in self.createButton() }
        
        // Timer to produce the buttons
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
                                            repeats: false)
        { _ in self.stopGameRunning() }
    }
    
    private func stopGameRunning() {
        // Stop the timer
        if let timer = newRectTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.newRectTimer = nil
        
        // Stop the timer
        if let timer = gameTimer { timer.invalidate() }
        
        // Remove the reference to the timer object
        self.gameTimer = nil
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

    @objc private func handlePress(sender: UIButton) {
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
            sender.setTitle("🎃", for: .normal)
        }
        print("\(#function) - \(isSelected!) - \(sender)")
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }
    
    // MARK: - ==== View Controller ====
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDict[defaultButton] = -1
        pairDict[defaultButton] = -1
        isSelected = defaultButton
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGameRunning()
    }


}

