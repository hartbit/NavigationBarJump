//
//  CycleViewController.swift
//  SwissResponder
//
//  Created by David Hart on 18/06/15.
//  Copyright (c) 2015 David Hart. All rights reserved.
//

import UIKit

func findIndex<S: SequenceType>(sequence: S, predicate: (S.Generator.Element) -> Bool) -> Int? {
	for (index, element) in enumerate(sequence) {
		if predicate(element) {
			return index
		}
	}
	
	return nil
}

class CycleViewController : UIViewController {
	var swapDuration: NSTimeInterval = 0.4
	var swapOptions: UIViewAnimationOptions = .allZeros
	var viewControllers: [UIViewController] = [] {
		willSet {
			if let childIndex = findIndex(self.viewControllers, { $0.parentViewController == self }) {
				self.unloadViewControllerAtIndex(childIndex)
			}
		}
		didSet {
			if self.viewControllers.count > 0 {
				self.loadViewControllerAtIndex(0)
			}
		}
	}
	
	//MARK: Actions
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if self.viewControllers.count > 0 {
			self.loadViewControllerAtIndex(0)
		}
	}
	
	@IBAction override func swap(sender: AnyObject?) {
		if self.viewControllers.count < 2 {
			return
		}
		
		let fromIndex = findIndex(self.viewControllers, { $0.parentViewController == self })!
		let fromViewController = self.viewControllers[fromIndex]
		let toViewController = self.viewControllers[(fromIndex + 1) % self.viewControllers.count]
			
		fromViewController.willMoveToParentViewController(nil)
		self.addChildViewController(toViewController)
			
		self.transitionFromViewController(fromViewController,
			toViewController: toViewController,
			duration: self.swapDuration,
			options: self.swapOptions,
			animations: {
				toViewController.view.frame = fromViewController.view.frame
			}, completion: { _ in
				fromViewController.removeFromParentViewController()
				toViewController.didMoveToParentViewController(self)
			})
	}
	
	//MARK: Public Methods
	
	func appendViewController(viewController: UIViewController) {
		self.viewControllers.append(viewController)
		
		if self.childViewControllers.count == 1 {
			self.loadViewControllerAtIndex(0)
		}
	}
	
	func insertViewController(viewController: UIViewController, atIndex index: Int) {
		self.viewControllers.insert(viewController, atIndex: index)
		
		if self.childViewControllers.count == 1 {
			self.loadViewControllerAtIndex(0)
		}
	}
	
	//MARK: Private Methods
	
	func loadViewControllerAtIndex(index: Int) {
		if self.isViewLoaded() {
			let viewController = self.viewControllers[index]
			self.addChildViewController(viewController)
			self.view.addSubview(viewController.view)
			viewController.didMoveToParentViewController(self)
		}
	}
	
	func unloadViewControllerAtIndex(index: Int) {
		if self.isViewLoaded() {
			let viewController = self.viewControllers[index]
			self.willMoveToParentViewController(nil)
			viewController.view.removeFromSuperview()
			viewController.removeFromParentViewController()
		}
	}
}

extension UIViewController {
	@IBAction func swap(sender: AnyObject?) {
		self.parentViewController?.swap(sender)
	}
}