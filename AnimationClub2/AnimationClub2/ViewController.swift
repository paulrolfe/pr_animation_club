//
//  ViewController.swift
//  AnimationClub2
//
//  Created by Paul Rolfe on 11/17/15.
//  Copyright © 2015 Paul Rolfe. All rights reserved.
//

import UIKit

let cellIdentifier = "leader cell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var playerArray: [Player] = []
    var animationCompletedIndexPaths: [NSIndexPath] = []
    var currentlyAnimatingIndexPaths: [NSIndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavButtons()
        setupTableView()
    }
    
    func setupNavButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Toggle Leaderboard", style: .Plain, target: self, action: "leftBarButtonItemTapped")
    }
    
    func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.blackColor()
    }
    
    func leftBarButtonItemTapped() {
        if playerArray.count > 0 {
            dropOutRows()
        } else {
            dropInRows()
        }
    }
    
    func dropOutRows() {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells.reverse() {
            let index = Double(visibleCells.reverse().indexOf(cell)!)
            let duration: Double = 0.5
            let delay =  (duration / 8) * index * pow(1.08, index)
            cell.frame = self.tableView.convertRect(cell.frame, toView: view)
            view.insertSubview(cell, aboveSubview: tableView)
            let targetFrame = CGRect(x: CGRectGetMinX(cell.frame), y: CGRectGetMaxY(tableView.frame) + CGRectGetMinY(cell.frame), width: CGRectGetWidth(cell.bounds), height: CGRectGetHeight(cell.bounds))
            UIView.animateWithDuration(duration, delay: delay, options: [.AllowAnimatedContent, .CurveEaseIn], animations: {
                cell.frame = targetFrame
                }, completion: { _ in
                    
                    if (visibleCells.indexOf(cell) == 0) {
                        //if it's the last cell, reload.
                        self.animationCompletedIndexPaths = []
                        self.currentlyAnimatingIndexPaths = []
                        self.playerArray = []
                        self.tableView.reloadData()
                    }

            })
        }
    }
    
    func dropInRows() {
        playerArray = samplePlayerArray().sort({ (p1, p2) in
            return p1.score > p2.score
        })
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LeaderboardTableViewCell
        let percent = Float(indexPath.row) / Float(playerArray.count)
        cell.contentView.backgroundColor = UIColor.anm_topScoreColor().colorAtPercent(percent, betweenColor: UIColor.anm_bottomScoreColor())
        cell.setupWithPlayer(playerArray[indexPath.row], topPlayer: playerArray.first!)
        cell.rankLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    func cellIsVisibleAtIndexPath(indexPath: NSIndexPath) -> Bool {
        var cellRect = tableView.rectForRowAtIndexPath(indexPath)
        cellRect = tableView.convertRect(cellRect, toView: tableView.superview)
        return CGRectIntersectsRect(tableView.frame, cellRect)
    }
    
    func needsAnimationAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return !animationCompletedIndexPaths.contains(indexPath) && !currentlyAnimatingIndexPaths.contains(indexPath) && cellIsVisibleAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if needsAnimationAtIndexPath(indexPath) {
            currentlyAnimatingIndexPaths.append(indexPath)
            let index = Double(currentlyAnimatingIndexPaths.indexOf(indexPath)!)
            let duration: Double = 0.5
            let delay =  (duration / 8) * index * pow(1.08, index)
            let targetFrame = cell.frame
            cell.frame = CGRect(x: CGRectGetMinX(cell.frame), y: CGRectGetMaxY(tableView.frame) + CGRectGetMinY(cell.frame), width: CGRectGetWidth(cell.bounds), height: CGRectGetHeight(cell.bounds))
            UIView.animateWithDuration(duration, delay: delay, options: [.AllowAnimatedContent, .CurveEaseOut], animations: {
                cell.frame = targetFrame
                }, completion: { _ in
                    if let index = self.currentlyAnimatingIndexPaths.indexOf(indexPath) {
                        self.currentlyAnimatingIndexPaths.removeAtIndex(index)
                    }
                    self.animationCompletedIndexPaths.append(indexPath)
            })
        }
    }
}

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var changeImageView: UIImageView!
    
    var ratioView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWithPlayer(player: Player, topPlayer: Player) {
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
        addContentLayerWithRatio(player.scoreRelativeToFirst(topPlayer.score))
    }
    
    internal func addContentLayerWithRatio(ratio: Double) {
        let ratioframe = CGRect(x: 0, y: 0, width: CGFloat(ratio) * CGRectGetMaxX(self.bounds), height: CGRectGetHeight(self.bounds))
        ratioView = UIView(frame: ratioframe)
        ratioView?.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        self.contentView.addSubview(ratioView!)
    }
    
    override func prepareForReuse() {
        self.ratioView?.removeFromSuperview()
    }
    
}

struct Player {
    var name: String
    var score: Int
    
    func scoreRelativeToFirst(first: Int) -> Double {
        return Double(score) / Double(first)
    }
}

func samplePlayerArray() -> [Player] {
    return [
        Player(name: "Paul", score: 50000),
        Player(name: "Logan", score: 20000),
        Player(name: "Andrew", score: 43000),
        Player(name: "Sara", score: 41000),
        Player(name: "Bryan", score: 49000),
        Player(name: "Eddy", score: 44000),
        Player(name: "Mark D", score: 34000),
        Player(name: "Mark K", score: 48000),
        Player(name: "Matt", score: 40000),
        Player(name: "Andrea", score: 44001),
        Player(name: "Tong", score: 34000),
        Player(name: "JR", score: 48000),
        Player(name: "Aaron", score: 40000),
        Player(name: "Brian", score: 44001)
    ]
}

extension UIColor {
    
    class func anm_topScoreColor() -> UIColor {
        return UIColor(red:0.37, green:0.76, blue:0.19, alpha:1)
    }
    
    class func anm_bottomScoreColor() -> UIColor {
        return UIColor(red:0.62, green:0.44, blue:0.38, alpha:1)
    }
    
    func colorAtPercent(percent: Float, betweenColor: UIColor) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        let done1 = self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        let done2 = betweenColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        if done1 && done2 {
            let newR = CGFloat(r1 + (r2 - r1) * CGFloat(percent))
            let newG = CGFloat(g1 + (g2 - g1) * CGFloat(percent))
            let newB = CGFloat(b1 + (b2 - b1) * CGFloat(percent))
            
            return UIColor(red: newR , green: newG, blue: newB, alpha: 1)
        } else {
            return self
        }
        

    }
}
