//
//  SwipingCardTableViewCell.swift
//  KMSwipingTableViewCell
//
//  Created by Khemmachart Chutapetch on 8/27/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

protocol SwipingCardTableViewCellDelegate: class {
    
    func didMoveLeft(atIndexPath indexPath: NSIndexPath)
    func didMoveRight(atIndexPath indexPath: NSIndexPath)
    
    func willMoveLeft(atIndexPath indexPath: NSIndexPath)
    func willMoveRight(atIndexPath indexPath: NSIndexPath)
}

class SwipingCardTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBackground: UIView!
    @IBOutlet private weak var slideLeftView: UIView!
    @IBOutlet private weak var slideRightView: UIView!
    
    weak var delegate: SwipingCardTableViewCellDelegate?
    
    var direction: Direction = .Left
    var isReachedScreenEdge = false
    var willBeRemoved = false
    
    override func layoutSubviews() {
        if !self.willBeRemoved {
            self.resetPosition(animation: false)
        }
    }
    
    func resetPosition(animation animation: Bool) {
        let frameWidth  = self.scrollView.frame.width
        scrollView.scrollRectToVisible(CGRectMake(frameWidth, 0, frameWidth, 100), animated: animation)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.detectDirection(scrollView.contentOffset.x)
        self.detectEdge(scrollView.contentOffset.x)
        self.detectPosition(scrollView.contentOffset.x)
    }
    
    func detectPosition(xPosition: CGFloat) {
        guard
            let tableView = self.superview?.superview as? UITableView,
            let indexPath = tableView.indexPathForCell(self),
            let delegate  = self.delegate
            else {
                return
        }
        
        switch direction {
        case .Left:
            isReachedScreenEdge ? delegate.didMoveLeft(atIndexPath: indexPath)  : delegate.willMoveLeft(atIndexPath: indexPath)
            break
        case .Right:
            isReachedScreenEdge ? delegate.didMoveRight(atIndexPath: indexPath) : delegate.willMoveRight(atIndexPath: indexPath)
            break
        case .None:
            // Do nothing
            break
        }
    }
    
    func detectEdge(xPosition: CGFloat) {
        let pageWidth = self.scrollView.frame.size.width
        let tailContentView = xPosition + pageWidth
        
        let reachRightEdge = tailContentView == self.scrollView.contentSize.width
        let reachLeftEdge  = xPosition == 0
        
        self.isReachedScreenEdge = reachLeftEdge || reachRightEdge
    }
    
    func detectDirection(xPosition: CGFloat) {
        let swipeLeft  = xPosition > self.scrollView.frame.size.width
        let swipeRight = xPosition < self.scrollView.frame.size.width
        
        self.direction = swipeLeft  ? .Left : swipeRight ? .Right : . None
    }
}

// MARK: Slide view

extension SwipingCardTableViewCell {
    
    // Accessor variatbles
    
    var viewForScrollViewBackground: UIView? {
        set {
            add(newValue!, forSlidingDirection: .None)
        }
        get {
            return getView(forSlidingDirection: .None)
        }
    }
    
    var viewForSlideLeft: UIView? {
        set {
            add(newValue!, forSlidingDirection: .Left)
        }
        get {
            return getView(forSlidingDirection: .Left)
        }
    }
    
    var viewForSlideRight: UIView? {
        set {
            add(newValue!, forSlidingDirection: .Right)
        }
        get {
            return getView(forSlidingDirection: .Right)
        }
    }
    
    // Accessor method
    
    func add(view: UIView, forSlidingDirection direction: Direction) {
        switch direction {
        case .Left:
            if let subview = getView(forSlidingDirection: .Left) {
                subview.removeFromSuperview()
            }
            self.slideLeftView.addSubview(view)
            self.slideLeftView.addConstraints(self.getConstraintsToFitSubview(view))
            break
        case .Right:
            if let subview = getView(forSlidingDirection: .Right) {
                subview.removeFromSuperview()
            }
            self.slideRightView.addSubview(view)
            self.slideRightView.addConstraints(self.getConstraintsToFitSubview(view))
            break
        case .None:
            if let subview = getView(forSlidingDirection: .None) {
                subview.removeFromSuperview()
            }
            self.scrollViewBackground.addSubview(view)
            self.scrollViewBackground.addConstraints(self.getConstraintsToFitSubview(view))
            break
        }
    }
    
    func getView(forSlidingDirection direction: Direction) -> UIView? {
        switch direction {
        case .Left:
            return slideLeftView.subviews.count  > 0 ? slideLeftView.subviews[0] : nil
        case .Right:
            return slideRightView.subviews.count > 0 ? slideRightView.subviews[0] : nil
        case .None:
            return scrollViewBackground.subviews.count > 0 ? scrollViewBackground.subviews[0] : nil
        }
    }
    
    // Constraint
    
    func getConstraintsToFitSubview(view: UIView) -> [NSLayoutConstraint] {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leading  = getConstraint(view: view, relatedView: view.superview!, attribute: .Leading)
        let trailing = getConstraint(view: view, relatedView: view.superview!, attribute: .Trailing)
        let top      = getConstraint(view: view, relatedView: view.superview!, attribute: .Top)
        let bottom   = getConstraint(view: view, relatedView: view.superview!, attribute: .Bottom)
        
        return [leading, trailing, top, bottom]
    }
    
    func getConstraint(view view: UIView, relatedView: UIView, attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view,
                                  attribute: attribute,
                                  relatedBy: NSLayoutRelation.Equal,
                                  toItem: relatedView,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0)
    }
    
}

extension SwipingCardTableViewCell {
    
    enum Direction {
        case Left
        case Right
        case None
    }
}