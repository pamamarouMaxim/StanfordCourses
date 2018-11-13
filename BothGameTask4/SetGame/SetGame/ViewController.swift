//
//  ViewController.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

protocol StartAndFinishGame {
  func startNewGameButton(_ sender: UIButton)
  func finishGame()
}
class ViewController: UIViewController {
    lazy var currentGame = getNewGame
    @IBOutlet var selectedСardViews: [UIView]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var tableOfGameView: UIView!
    @IBOutlet weak var usedCardsImageView: UIImageView!
    @IBOutlet weak var addCards: UIButton!
  
    lazy var animator = UIDynamicAnimator(referenceView: view)
  
    lazy var cardBehavior = CardBehavior(in: animator)
  
    var cardAspectRatio : CGFloat {
        let tableWidth = tableOfGameView.bounds.width
        let tableHeight = tableOfGameView.bounds.height
        return tableWidth > tableHeight ? tableHeight / tableWidth : tableWidth / tableHeight
    }
  
    var getNewGame: PlayingCardDeck {
            return PlayingCardDeck()
    }
    var playingCardViews = [PlayingCardView]()
    var tapPlayingViewGesture: UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(ViewController.tapPlayingCardView(_:)))
        return tapGesture
    }
    @IBAction func addCardsButton(_ sender: UIButton) {
        addCardToView(count: 3)
        putCardsOnView()
    }
    @IBAction func findSetButton(_ sender: UIButton) {
        if let setIndexes = currentGame.findSet() {
            playingCardViews.filter({setIndexes.contains($0.identifire)}).forEach({$0.containInSet()})
        }
    }
    @objc private func shufflePlayingCard (_ sender: UIGestureRecognizer) {
      switch sender.state {
      case .began:
          playingCardViews.forEach { (view) in
              self.cardBehavior.addItem(view)
          }
          playingCardViews.shuffle()
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.playingCardViews.forEach { (view) in
                  self.cardBehavior.removeItem(view)
                  view.transform = CGAffineTransform.identity
              }
              self.putCardsOnView()
          }
      default: break
      }
    }
    private func putCardsOnView() {
        if currentGame.identifireInDesk.count > 0 && currentGame.findSet() == nil {
            addCardsButton(UIButton())
            return
        }
        var grid = Grid(layout: .aspectRatio(cardAspectRatio),
                         frame: tableOfGameView.bounds)
        grid.cellCount = playingCardViews.count
        var i : Double = 0
        for (index, playingCardView) in playingCardViews.enumerated() {
            guard let viewFrame = grid[index] else {return}
            i = i + (!playingCardView.isFaceUp ? 0.1 : 0)
            UIView.animate(withDuration: 0.5,
                           delay: i,
                           options: [],
                           animations: {
                           playingCardView.frame = viewFrame.insetBy(dx: viewFrame.width * 0.05,
                                                                     dy: viewFrame.height * 0.05)
                           if !playingCardView.isFaceUp {
                              for circleCount in 1...4 {
                                UIView.animateKeyframes(withDuration: 0.5, delay: i, options: [], animations: {
                                    playingCardView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * CGFloat(circleCount))
                                }, completion: nil)
                              }
                           }
            }) { completion in
                playingCardView.setNeedsLayout()
                if completion && !playingCardView.isFaceUp {
                  playingCardView.subviews.forEach({$0.removeFromSuperview()})
                  playingCardView.isFaceUp = true
                  playingCardView.setNeedsDisplay()
                  UIView.transition(with: playingCardView,
                                    duration: 0.5, options: [.transitionFlipFromLeft],
                                    animations: nil,
                                    completion: nil)
                }
          }
        }
        finishGame()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.green
        let addCardsSwipe = UISwipeGestureRecognizer(target: self,
                                                     action: #selector(ViewController.addCardsButton(_:)))
        addCardsSwipe.direction = [.down]
        let shuffleGesture = UIRotationGestureRecognizer(target: self,
                                                         action: #selector(ViewController.shufflePlayingCard(_:)))
        view.addGestureRecognizer(addCardsSwipe)
        view.addGestureRecognizer(shuffleGesture)
        tableOfGameView.superview?.bringSubviewToFront(tableOfGameView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startNewGameButton(UIButton())
     
    }
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            if self.tableOfGameView != nil {
                 self.putCardsOnView()
            }
        }
    }
    private func addCardToView(count: Int) {
        let cards = currentGame.giveCards(count: count)
        let deskRect = newGameButton.superview?.convert(newGameButton.frame, to: tableOfGameView)
        guard let cardFrame = deskRect else {return}
        var cardsArray = [PlayingCardView]()
        for card in cards {
            let playingCardView = PlayingCardView(frame: cardFrame,
                                                  symbol: card.cardSymbol,
                                                  symbolCount: card.symbolCount,
                                                  symbolColor: card.symbolColor,
                                                  symbolFilling: card.symbolFilling,
                                                  identifire: card.identifire)
            playingCardView.addGestureRecognizer(tapPlayingViewGesture)
            cardsArray.append(playingCardView)
            let image = UIImageView(image: #imageLiteral(resourceName: "HCT-cardback"))
            image.frame = CGRect(x: 0, y: 0, width: playingCardView.bounds.width,
                                            height: playingCardView.bounds.height)
            playingCardView.addSubview(image)
            image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableOfGameView.addSubview(playingCardView)
        }
        cardsArray.reverse()
        playingCardViews += cardsArray
    }

    @objc private func tapPlayingCardView(_ gesture: UITapGestureRecognizer) {
        if let playingCardView = gesture.view as? PlayingCardView {
            currentGame.selectedCard(WithIdentifire: playingCardView.identifire,
                                     closure: { (wasSelected, isSet, selectedCards) in
                playingCardView.viewWasSelected(wasSelected)
                guard let selectedCards = selectedCards else { return }
                if selectedCards.count > 3 {
                    var array = playingCardViews.filter({selectedCards.contains($0.identifire)})
                    array = array.filter({$0.identifire != playingCardView.identifire})
                    _ = array
                    array.forEach({$0.viewWasSelected(true)})
                    return
                }
                guard let isSet = isSet else { return }
                if isSet {
                    let rect = usedCardsImageView.superview?.convert(usedCardsImageView.frame, to: tableOfGameView)
                    let setCards = playingCardViews.filter({selectedCards.contains($0.identifire)})
                    for playingView in setCards {
                        guard let index = playingCardViews.index(of: playingView) else { return }
                        self.playingCardViews.remove(at: index)
                        tableOfGameView.bringSubviewToFront(playingView)
                    }
                    setCards.forEach({view in cardBehavior.addItem(view)})
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        setCards.forEach({view in self.cardBehavior.removeItem(view)})
                        UIView.animate(withDuration: 0.4, animations: {
                            setCards.forEach({view in view.frame = rect!})
                      }, completion: { (_) in
                            setCards.forEach({view in view.removeFromSuperview()})
                            if self.playingCardViews.count >= 12 || self.currentGame.identifireInDesk.count == 0 {
                                self.putCardsOnView()
                            } else {
                                self.addCardsButton(UIButton())
                          }
                      })
                    })
                } else {
                  _ = playingCardViews.filter({selectedCards.contains($0.identifire)}).map({$0.shake()})
                }
            })
        }
      addSelectedCards()
    }
    func addSelectedCards() {
        _ = selectedСardViews.map({$0.subviews.first?.removeFromSuperview()})
        for (index, selectedIndex) in currentGame.selectedIdentifire.enumerated() {
            if let playingCardView = playingCardViews.filter({$0.identifire == selectedIndex}).first {
                let playingCardViewCopy = playingCardView.copyView()
                playingCardViewCopy.isFaceUp = true
                playingCardViewCopy.frame = selectedСardViews[index].bounds
                selectedСardViews[index].addSubview(playingCardViewCopy)
            }
      }
    }
}

extension ViewController: StartAndFinishGame {
    @IBAction func startNewGameButton(_ sender: UIButton) {
        addCards.isHidden = false
        addCards.isEnabled = true
        currentGame = getNewGame
        selectedСardViews.forEach({$0.subviews.forEach({$0.removeFromSuperview()})})
        playingCardViews.forEach({$0.removeFromSuperview()})
        playingCardViews.removeAll()
        addCardToView(count: 12)
        putCardsOnView()
    }
    internal func finishGame() {
        if currentGame.identifireInDesk.count == 0 {
            addCards.isEnabled = false
            if  currentGame.findSet() == nil {
                let alert = UIAlertController(title: "Game over",
                                              message: "",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Start new game", style: .default,
                                              handler: { _ in
                                                self.startNewGameButton(UIButton())
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


