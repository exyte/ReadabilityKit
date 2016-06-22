//
//  DetailsController.swift
//  ReadabilityKit
//
//  Created by Victor Sukochev on 22/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ReadabilityKit

class DetailsController: UIViewController {

	@IBAction func onDone() {
		self.dismissViewControllerAnimated(true, completion: .None)
	}

	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var imageView: UIImageView?
	@IBOutlet weak var keywordsLabel: UILabel?
	@IBOutlet weak var descriptionView: UITextView?

	var url: NSURL? {
		didSet {
			parseUrl()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		parseUrl()
	}

	func parseUrl() {
		guard let url = url else {
			return
		}

		guard let htmlData = NSData(contentsOfURL: url) else {
			return
		}

		let parser = Readability(data: htmlData)

		titleLabel?.text = parser.title()
		descriptionView?.text = parser.description()
		if let keywords = parser.keywords() {
			keywordsLabel?.text = keywords.joinWithSeparator(" ")
		}

		guard let imageUrlStr = parser.imageUrl() else {
			return
		}

		guard let imageUrl = NSURL(string: imageUrlStr) else {
			return
		}

		guard let imageData = NSData(contentsOfURL: imageUrl) else {
			return
		}

		let image = UIImage(data: imageData)
		imageView?.image = image
	}
}
