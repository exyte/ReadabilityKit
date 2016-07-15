//
//  MainController.swift
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

class MainController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

	@IBOutlet weak var addressField: UITextField?
	@IBOutlet weak var webView: UIWebView?
	@IBOutlet weak var activityView: UIView?

	var url: NSURL?
	var parser: Readability?
	var image: UIImage?

	override func viewDidLoad() {
		super.viewDidLoad()

		loadDefaultPage()
	}

	@IBAction func onGo() {
		addressField?.resignFirstResponder()

		guard let addressStr = addressField?.text else {
			return
		}

		var urlStr = addressStr
		if !urlStr.containsString("https://") &&
		!urlStr.containsString("http://") {
			urlStr = "https://\(urlStr)"
		}

		url = NSURL(string: urlStr)
		guard let url = url else {
			return
		}

		let request = NSURLRequest(URL: url)
		webView?.loadRequest(request)
	}

	@IBAction func onParse() {

		UIView.animateWithDuration(0.1, animations: {
			self.activityView?.alpha = 1.0
		}) { _ in
			self.parseUrl()
			self.moveToDetails()
		}
	}

	func moveToDetails() {
		UIView.animateWithDuration(0.1, animations: {
			self.activityView?.alpha = 0.0
		}) { _ in
			self.performSegueWithIdentifier("details_segue", sender: .None)
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == "details_segue" {

			let detailsController = segue.destinationViewController as? DetailsController

			detailsController?.titleText = parser?.title()
			detailsController?.desc = parser?.description()
			detailsController?.keywords = parser?.keywords()
			detailsController?.image = image
		}
	}

	func loadDefaultPage() {
		guard let url = NSURL(string: "https://google.com") else {
			return
		}

		let request = NSURLRequest(URL: url)
		webView?.loadRequest(request)
	}

	// MARK: UIWebView delegate
	func webViewDidFinishLoad(webView: UIWebView) {
		url = webView.request?.URL
		guard let urlStr = url?.absoluteString else {
			return
		}

		addressField?.text = urlStr
	}

	// MARK: UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		onGo()

		return true
	}

	// MARK: Parsing

	func parseUrl() {
		guard let url = url else {
			return
		}

		guard let htmlData = NSData(contentsOfURL: url) else {
			return
		}

		parser = Readability(data: htmlData)

		guard let imageUrlStr = parser?.topImage() else {
			return
		}

		guard let imageUrl = NSURL(string: imageUrlStr) else {
			return
		}

		guard let imageData = NSData(contentsOfURL: imageUrl) else {
			return
		}

		image = UIImage(data: imageData)
	}
}
