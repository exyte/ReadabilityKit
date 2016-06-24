//
//  DetailsController.swift
//  ReadabilityKit
//
//  Copyright (c) 2016 Exyte http://www.exyte.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import ReadabilityKit

class DetailsController: UIViewController {

	@IBAction func onDone() {
		self.dismissViewControllerAnimated(true, completion: .None)
	}

	@IBOutlet weak var titleView: UITextView?
	@IBOutlet weak var imageView: UIImageView?
	@IBOutlet weak var keywordsView: UITextView?
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

		titleView?.text = parser.title()
		descriptionView?.text = parser.description()
		if let keywords = parser.keywords() {
			keywordsView?.text = keywords.joinWithSeparator(" ")
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
