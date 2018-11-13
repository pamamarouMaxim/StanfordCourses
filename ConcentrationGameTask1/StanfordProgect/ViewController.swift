//
//  ViewController.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/5/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var currentGame = newGame
    lazy var labelAttributes = gameAttributes
  
    private var newGame: Concentration {
      return Concentration(numberOfPairsOfCards: (cardsCollection.count + 1 ) / 2)
    }

    private var gameAttributes: [NSAttributedStringKey: Any] {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 2
        myShadow.shadowOffset = CGSize(width: 1, height: 1)
        myShadow.shadowColor = UIColor.gray
        let attributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: currentGame.gameTheme.cardColor,
            .shadow: myShadow
            ]
        return attributes
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      startNewGame(UIButton())
    }
 
    @IBOutlet var cardsCollection: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var startNewGameButton: UIButton!
  
    @IBAction func startNewGame(_ sender: UIButton) {
        currentGame = newGame
        labelAttributes = gameAttributes
        for button in cardsCollection {
          animated(Button: button,
                   color: currentGame.gameTheme.cardColor,
                   title: "",
                   optional: .transitionFlipFromLeft,
                   animationDuration: 0.3)
        }
        view.backgroundColor = currentGame.gameTheme.background
        updateScoreAndFlip()
        addMaxScore()
        recordLabel.attributedText = NSAttributedString(string: recordLabel.text!, attributes: labelAttributes)
        startNewGameButton.setAttributedTitle(NSAttributedString(string: startNewGameButton.currentTitle!, attributes: labelAttributes), for: .normal
      )
    }
  
    @IBAction func tapCard(_ sender: UIButton) {
        if let cardNumber = cardsCollection.index(of: sender) {
            currentGame.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
  
    private func updateViewFromModel() {
        for index in cardsCollection.indices {
            let button = cardsCollection[index]
            let card = currentGame.cards[index]
            if card.isFaceUp {
                if button.currentTitle == "" && button.backgroundColor != UIColor.clear {
                    animated(Button: button,
                             color: UIColor.white,
                             title: card.emoji,
                             optional: .transitionFlipFromLeft,
                             animationDuration: 0.3)
                }
            } else {
                if button.currentTitle != "" && button.backgroundColor == UIColor.white && !card.isMadched{
                    animated(Button: button,
                             color: currentGame.gameTheme.cardColor,
                             title: "",
                             optional: .transitionFlipFromLeft,
                             animationDuration: 0.3)
                }
            }
            if card.isMadched {
                if button.currentTitle != "" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {[weak self] in
                        self?.animated(Button: button,
                                       color: UIColor.clear,
                                       title: "",
                                       optional: .transitionCrossDissolve,
                                       animationDuration: 1)
                    })
                }
            }
          }
      updateScoreAndFlip()
      currentGame.cards.filter ( {$0.isMadched == false} ).count == 0 ? showAlertEndGame() : ()
  }

      private func animated(Button button: UIButton,
                            color: UIColor,
                            title: String,
                            optional: UIViewAnimationOptions,
                            animationDuration: Double) {
            UIView.transition(with: button, duration: animationDuration, options: optional, animations: {
              button.backgroundColor = color
              button.setTitle(title, for: .normal)
            }, completion: { _ in })
      }
  
  
      private func showAlertEndGame() {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
              let alert = UIAlertController(title: "Congratulations!!!",
                                            message: "\(String(describing: self.scoreLabel.text!)) \n \(self.flipCountLabel.text!)",
                                            preferredStyle: UIAlertControllerStyle.alert)
              alert.addAction(UIAlertAction(title: "Start new game",
                                            style: .default,
                                            handler: { action in
              self.addMaxScore()
              self.startNewGame(UIButton())
              }))
              self.present(alert, animated: true, completion: nil)
          })
      }
  
      private func addMaxScore() {
          if let maxScore = UserSettings.default.maxScore{
              if maxScore < currentGame.score{
                UserSettings.default.maxScore = currentGame.score
              }
              recordLabel.text = "Max score = \( UserSettings.default.maxScore!)"
          } else {
              UserSettings.default.maxScore = 0
              recordLabel.text = "Max score = 0"
          }
      }
  
      private func updateScoreAndFlip() {
          flipCountLabel.text = "Flips : \(currentGame.flipCount)"
          scoreLabel.text = "Score : \(currentGame.score)"
          scoreLabel.attributedText = NSAttributedString(string: scoreLabel.text!,
                                                         attributes: labelAttributes)
          flipCountLabel.attributedText = NSAttributedString(string: flipCountLabel.text!,
                                                             attributes: labelAttributes)
      }
}
