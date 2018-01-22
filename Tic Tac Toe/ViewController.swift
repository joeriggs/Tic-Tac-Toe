//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Joe Riggs on 12/30/17.
//  Copyright © 2017 Joe Riggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var winnerLabel: UILabel!

    @IBOutlet weak var ticTacToeBoardLandscapeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ticTacToeBoardTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dashboardViewLeadingPortraitConstraint: NSLayoutConstraint!
    @IBOutlet weak var dashboardViewLeadingLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak var dashboardViewLandscapeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dashboardViewPortraitTopConstraint: NSLayoutConstraint!
    
    var gameActive = false

    // 1 = X, 2 = O
    // sqsuareOwners indexes are relative to zero.
    var whoseTurn = 1
    var squareOwners = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

    // Which square was used during each move.  This allows us to perform the Undo
    // operations.
    var movesCounter = 0
    var moves = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]  // The square for each move.

    let winningCombinations = [ [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6] ]
    
    func startNewGame() {
        winnerLabel.isHidden = true

        gameActive = true
        whoseTurn = 1
        squareOwners = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: [])
        }
    }

    @IBAction func startNewGamePressed(_ sender: Any) {
        startNewGame()
    }

    @IBAction func undoLastMove(_ sender: Any) {
        if movesCounter > 0 {
            movesCounter -= 1
            let move = moves[movesCounter]
            print("undoLastMove(): Before: move = \(move).  squareOwners = \(squareOwners)")
            squareOwners[move - 1] = 0
            print("undoLastMove(): After: squareOwners = \(squareOwners)")
            let button = view.viewWithTag(move) as! UIButton
            button.setImage(nil, for: [])
            if whoseTurn == 1 {
                whoseTurn = 2
            } else {
                whoseTurn = 1
            }
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if gameActive {
            let tag = sender.tag
            //print("\(tag) pressed")

            let index = tag - 1
            print("buttonPressed(): index = \(index).  squareOwners = \(squareOwners)")
            if squareOwners[index] == 0 {
                squareOwners[index] = whoseTurn

                moves[movesCounter] = tag
                movesCounter += 1

                if whoseTurn == 1 {
                    sender.setImage(UIImage(named: "x_img.png"), for: [])
                    whoseTurn = 2
                } else {
                    sender.setImage(UIImage(named: "o_img.png"), for: [])
                    whoseTurn = 1
                }
                
                for combination in winningCombinations {
                    if squareOwners[combination[0]] != 0 && squareOwners[combination[0]] == squareOwners[combination[1]] && squareOwners[combination[1]] == squareOwners[combination[2]] {

                        gameActive = false

                        if squareOwners[combination[0]] == 1 {
                            winnerLabel.text = "X is the winner!"
                        } else {
                            winnerLabel.text = "O is the winner!"
                        }
                        winnerLabel.isHidden = false
                    }
                }
                
                // If we didn't find a winner, check for a draw.
                if gameActive {
                    for i in 0...8 {
                        if squareOwners[i] == 0 {
                            break
                        }

                        if i == 8 {
                            // We have a draw.
                            gameActive = false
                            winnerLabel.text = "Draw!"
                            winnerLabel.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewGame()
    }

    /* This function is called when the use rotates between portrait and landscape modes.
     * It allows us to rotate the grid and keep is square.
     */
    override func viewDidLayoutSubviews() {
        let bounds = self.view.bounds
        //print("width: \(bounds.width): height \(bounds.height)")
        
        if bounds.height >= bounds.width {
            ticTacToeBoardTrailingConstraint.isActive         = true
            ticTacToeBoardLandscapeBottomConstraint.isActive  = false
            dashboardViewLandscapeTopConstraint.isActive      = false
            dashboardViewPortraitTopConstraint.isActive       = true
            dashboardViewLeadingLandscapeConstraint.isActive  = false
            dashboardViewLeadingPortraitConstraint.isActive   = true
        } else {
            ticTacToeBoardTrailingConstraint.isActive         = false
            ticTacToeBoardLandscapeBottomConstraint.isActive  = true
            dashboardViewPortraitTopConstraint.isActive       = false
            dashboardViewLandscapeTopConstraint.isActive      = true
            dashboardViewLeadingPortraitConstraint.isActive   = false
            dashboardViewLeadingLandscapeConstraint.isActive  = true
        }
    }

}

