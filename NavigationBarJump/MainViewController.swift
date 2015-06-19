//
//  MainViewController.swift
//  SwissResponder
//
//  Created by David Hart on 18/06/15.
//  Copyright (c) 2015 David Hart. All rights reserved.
//

import UIKit

let frontSegueIdentifier: String = "Front"
let backSegueIdentifier: String = "Back"

class MainViewController : CycleViewController {
	//MARK: UIViewController Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.swapOptions = .TransitionFlipFromLeft
		self.performSegueWithIdentifier(frontSegueIdentifier, sender: self)
		self.performSegueWithIdentifier(backSegueIdentifier, sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
		case frontSegueIdentifier:
			self.appendViewController(segue.destinationViewController as! UIViewController)
		case backSegueIdentifier:
			self.appendViewController(segue.destinationViewController as! UIViewController)
		default:
			super.prepareForSegue(segue, sender: sender)
		}
	}
}
