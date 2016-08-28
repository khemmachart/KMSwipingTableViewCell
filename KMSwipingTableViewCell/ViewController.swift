//
//  ViewController.swift
//  KMSwipingTableViewCell
//
//  Created by Khemmachart Chutapetch on 8/27/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var content: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension ViewController {
    
    func removeCard(atIndexPath indexPath: NSIndexPath) {
        self.content > 2 ? self.removeCellSuccess(atIndexPath: indexPath) : self.removeCellFailed(atIndexPath: indexPath)
    }
    
    func removeCellFailed(atIndexPath indexPath: NSIndexPath) {
        let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as! SwipingCardTableViewCell
        currentCell.resetPosition(animation: true)
    }
    
    func removeCellSuccess(atIndexPath indexPath: NSIndexPath) {
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        (self.tableView.cellForRowAtIndexPath(indexPath) as! SwipingCardTableViewCell).willBeRemoved = true
        self.content -= 1
        self.tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cellId = "SwipingCardTableViewCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SwipingCardTableViewCell else {
            return UITableViewCell()
        }
        cell.layoutIfNeeded()
        let bg = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        bg.backgroundColor = UIColor.redColor()
        cell.viewForSlideLeft = bg
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content
    }
}

extension ViewController: SwipingCardTableViewCellDelegate {
    
    func didMoveLeft(atIndexPath indexPath: NSIndexPath) {
        self.removeCard(atIndexPath: indexPath)
    }
    
    func didMoveRight(atIndexPath indexPath: NSIndexPath) {
        self.removeCard(atIndexPath: indexPath)
    }
    
    func willMoveLeft(atIndexPath indexPath: NSIndexPath) {
        // self.removeCard(atIndexPath: indexPath)
    }
    
    func willMoveRight(atIndexPath indexPath: NSIndexPath) {
        // self.removeCard(atIndexPath: indexPath)
    }
}
