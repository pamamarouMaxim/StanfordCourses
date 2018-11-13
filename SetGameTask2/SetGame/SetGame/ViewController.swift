//
//  ViewController.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/14/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var currentGame = getNewGame
    @IBOutlet var selectedСardViews: [UIView]!
    @IBOutlet weak var tableOfGameView: UIView!
    var getNewGame: PlayingCardDeck {
        return PlayingCardDeck()
    }
    var playingCardViews = [PlayingCardView]()
    var tapPlayingViewGesture: UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(ViewController.tapPlayingCardView(_:)))
        return tapGesture
    }
    private var arrayRowStackViews = [UIStackView]()
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
          playingCardViews.shuffle()
          putCardsOnView()
      default: break
      }
    }
    private func putCardsOnView() {
        var grid = Grid(layout: .aspectRatio(tableOfGameView.bounds.width / tableOfGameView.bounds.height),
                       frame: tableOfGameView.bounds)
        grid.cellCount = playingCardViews.count
        for (index, playingCardView) in playingCardViews.enumerated() {
            guard let viewFrame = grid[index] else { return }
            UIView.animate(withDuration: 1, animations: {
              playingCardView.frame = viewFrame.insetBy(dx: viewFrame.width * 0.05,
                                                        dy: viewFrame.height * 0.05)
            })
            tableOfGameView.addSubview(playingCardView)
        }
        finishGame()
    }
    private func finishGame() {
        if currentGame.identifireInDesk.count == 0 && currentGame.findSet() == nil {
            let alert = UIAlertController(title: "Game over",
                                          message: "",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Start new game", style: .default,
                                          handler: { _ in
              self.startNewGame(UIBarButtonItem())
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let startNewGameButton = UIBarButtonItem(title: "Start new game",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(ViewController.startNewGame(_:)))
        navigationItem.rightBarButtonItem = startNewGameButton
        navigationController?.navigationBar.backgroundColor = UIColor.green
        navigationController?.navigationBar.tintColor = UIColor.red
        startNewGame(startNewGameButton)
        let addCardsSwipe = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(ViewController.addCardsButton(_:)))
        addCardsSwipe.direction = [.down]
        let shuffleGesture = UIRotationGestureRecognizer(target: self,
                                                        action: #selector(ViewController.shufflePlayingCard(_:)))
        view.addGestureRecognizer(addCardsSwipe)
        view.addGestureRecognizer(shuffleGesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        putCardsOnView()
    }
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.putCardsOnView()
        }
    }
    private func addCardToView(count: Int) {
        let cards = currentGame.giveCards(count: count)
        for card in cards {
            let playingCardView = PlayingCardView(frame: CGRect.zero,
                                                  symbol: card.cardSymbol,
                                                  symbolCount: card.symbolCount,
                                                  symbolColor: card.symbolColor,
                                                  symbolFilling: card.symbolFilling,
                                                  identifire: card.identifire)
            playingCardView.addGestureRecognizer(tapPlayingViewGesture)
            playingCardViews.append(playingCardView)
        }
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
                    array.forEach({$0.viewWasSelected(false)})
                    return
                }
                guard let isSet = isSet else { return }
                if isSet {
                    for playingView in playingCardViews.filter({selectedCards.contains($0.identifire)}) {
                        guard let index = playingCardViews.index(of: playingView) else { return }
                      UIView.animate(withDuration: 0.4, animations: {
                        playingView.frame = CGRect.zero
                      }, completion: { (_) in
                        self.playingCardViews.remove(at: index)
                        playingView.removeFromSuperview()
                        if self.playingCardViews.count >= 12 || self.currentGame.identifireInDesk.count == 0 {
                          self.putCardsOnView()
                        } else {
                          self.addCardsButton(UIButton())
                        }
                      })
                    }
                } else {
                  _ = playingCardViews.filter({selectedCards.contains($0.identifire)}).map({$0.shake()})
                }
            })
        }
      addSelectedCards()
    }
    @objc private func startNewGame(_ sender: UIBarButtonItem) {
        currentGame = getNewGame
        playingCardViews.forEach({$0.removeFromSuperview()})
        playingCardViews.removeAll()
        addCardToView(count: 12)
        putCardsOnView()
    }
    func addSelectedCards() {
        _ = selectedСardViews.map({$0.subviews.first?.removeFromSuperview()})
        for (index, selectedIndex) in currentGame.selectedIdentifire.enumerated() {
            if let playingCardView = playingCardViews.filter({$0.identifire == selectedIndex}).first {
                let playingCardViewCopy = playingCardView.copyView()
                playingCardViewCopy.frame = selectedСardViews[index].bounds
                selectedСardViews[index].addSubview(playingCardViewCopy)
            }
      }
    }
}
